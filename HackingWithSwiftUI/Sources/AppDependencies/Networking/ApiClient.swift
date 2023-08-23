//
//  ApiClient.swift
//
//
//  Created by Илья Шаповалов on 20.08.2023.
//

import Foundation
import SwiftFP
import Combine
import OSLog

// (URL) -> URLRequest
// (URLRequest) -> URLSession
// (URLSession) -> AnyPublisher<(data: Data, response: URLResponse), Error>
// (AnyPublisher<response, error>) -> AnyPublisher<T, Error>

// Error handling?

// (URL) -> AnyPublisher<T, Error>

public struct ApiClient {
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    typealias Request = (URLRequest) -> URLRequest
    public typealias ResponsePublisher = AnyPublisher<(data: Data, response: URLResponse), Error>
    
    private let session: URLSession
    
    public static let shared = Self()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func send<T: Decodable>(order: Encodable) -> AnyPublisher<T, Error> {
        postRequest(content: order, endpoint: .sendOrder)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    public func postRequest(content: Encodable, endpoint: Endpoint) -> ResponsePublisher {
        compose(
            configRequest(method: .POST),
            addContentData(content),
            uploadTaskPublisher(session: session)
        )(endpoint)
    }
}

private extension ApiClient {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func configRequest(method: HTTPMethod) -> (Endpoint) -> URLRequest {
        {
            compose(
                makeRequest(method),
                setHeader("Content-Type", value: "application/json")
            )($0.url)
        }
    }
    
    func configSession(_ config: URLSessionConfiguration = .default) -> URLSession {
     //   var config = config
        return URLSession(configuration: config)
    }
    
    func makeRequest(_ method: HTTPMethod) -> (URL) -> URLRequest {
        {
            var request = URLRequest(url: $0)
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    func setHeader(_ header: String, value: String) -> Request {
        {
            var request = $0
            request.setValue(value, forHTTPHeaderField: header)
            return request
        }
    }
    
    func addContentData<T: Encodable>(_ content: T) -> (URLRequest) -> (URLRequest, Data) {
        {
            do {
                let encoded = try JSONEncoder().encode(content)
                return ($0, encoded)
            } catch {
                fatalError("Failed to encode model: \(error.localizedDescription)")
            }
        }
    }
    
    func dataTaskPublisher(session: URLSession) -> (URLRequest) -> ResponsePublisher {
        {
            URLSession
                .DataTaskPublisher(request: $0, session: session)
                .mapError { $0 }
                .eraseToAnyPublisher()
        }
    }
    
    func uploadTaskPublisher(session: URLSession) -> (URLRequest, Data) -> ResponsePublisher {
        { request, data in
            Future<(data: Data, response: URLResponse), Error> { promise in
                Task {
                    do {
                        let result = try await session.upload(for: request, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    }
    
}
