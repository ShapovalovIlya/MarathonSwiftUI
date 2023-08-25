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
        postRequest(
            url: CupcakesEndpoint.sendOrder.url,
            content: order
        )
        .map(\.data)
        .decode(type: T.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    public func postRequest(url: URL, content: Encodable) -> ResponsePublisher {
        compose(
            configRequest(method: .POST),
            addData(from: content),
            dataTaskPublisher(session: session)
        )(url)
    }
}

private extension ApiClient {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func configRequest(method: HTTPMethod) -> (URL) -> URLRequest {
        {
            compose(
                makeRequest(method),
                setHeader("Content-Type", value: "application/json")
            )($0)
        }
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
    
    func addData(from model: Encodable) -> Request {
        {
            var request = $0
            do {
                request.httpBody = try JSONEncoder().encode(model)
                return request
            } catch {
                preconditionFailure("Unable to encode \(String(describing: model)). Reason: \(error.localizedDescription)")
            }
        }
    }
    
    func dataTaskPublisher(session: URLSession = .shared) -> (URLRequest) -> ResponsePublisher {
        {
            URLSession
                .DataTaskPublisher(request: $0, session: session)
                .mapError { $0 }
                .eraseToAnyPublisher()
        }
    }
    
}
