//
//  APIService.swift
//  GalleryApp
//
//  Created by Maksim Kuklitski on 28.03.24.
//

import Foundation
import Combine

protocol APIServiceProtocol: AnyObject {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

final class APIService: APIServiceProtocol {
    
    static let instance = APIService()
    
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        
        guard let urlRequest = try? makeURLRequest(from: endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        debugPrint("Making request to: \(urlRequest)")
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                debugPrint("Received response from: \(response.url?.absoluteString ?? "")")
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
                }
                let value: T = try self.decodeResponseData(data, withDecoder: endpoint.decoder)
                return value
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return .unknown(error)
                }
            }
            .handleEvents(receiveSubscription: { _ in
                debugPrint("Network request started: \(endpoint)")
            }, receiveOutput: { response in
                debugPrint("Network request succeeded: \(response)")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("Network request finished successfully.")
                case .failure(let error):
                    debugPrint("Network request failed with error: \(error)")
                }
            }, receiveCancel: {
                debugPrint("Network request canceled.")
            })
            .eraseToAnyPublisher()
    }
    
    private func makeURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let url = URL(string: endpoint.path, relativeTo: endpoint.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let httpMethod = endpoint.httpMethod
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        addHeaders(to: &urlRequest, from: endpoint)
        
        switch httpMethod {
        case .get:
            try addParameters(toURL: &urlRequest, from: endpoint)
        }
        
        return urlRequest
    }
    
    private func decodeResponseData<T: Decodable>(
        _ data: Data,
        withDecoder decoder: JSONDecoder
    ) throws -> T {
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
    
    private func addHeaders(to urlRequest: inout URLRequest, from endpoint: Endpoint) {
        if let headers = endpoint.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        if !(urlRequest.allHTTPHeaderFields?.contains(where: { key, _ in key == "Content-Type" }) ?? false) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    private func addParameters(toURL urlRequest: inout URLRequest, from endpoint: Endpoint) throws {
        guard let parameters = endpoint.parameters, !parameters.isEmpty, let urlRequestURL = urlRequest.url else { return }
        
        var urlComponents = try createURLComponents(from: urlRequestURL)
        
        let mappedParameters = parameters.mapValues { value -> Any in
            if let valueArray = value as? [Any] {
                return valueArray.map { String(describing: $0) }
            } else {
                return value
            }
        }
        
        let queryItems = try createQueryItems(from: mappedParameters)
        
        urlComponents.queryItems = queryItems
        urlRequest.url = urlComponents.url
    }
    
    private func createURLComponents(from url: URL) throws -> URLComponents {
        guard let urlComponents = URLComponents(string: url.absoluteString) else {
            throw NetworkError.invalidURL
        }
        
        return urlComponents
    }
    
    private func createQueryItems(from parameters: [String: Any]) throws -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            if let valueArray = value as? [String] {
                queryItems.append(contentsOf: valueArray.map { URLQueryItem(name: key + "[]", value: $0) })
            } else {
                queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
        }
        return queryItems
    }
}
