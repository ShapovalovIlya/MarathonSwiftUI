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
    private let session: URLSession
    typealias Request = (URLRequest) -> URLRequest
    public typealias ResponsePublisher = AnyPublisher<(data: Data, response: URLResponse), Error>
    
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
    
    func getRequest<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        compose(
            makeRequest(.GET),
            dataTaskPublisher(session: session)
        )(url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    
    public func postRequest(url: URL, content: Encodable) -> ResponsePublisher {
        compose(
            makeRequest(.POST),
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
    
    func makeRequest(_ method: HTTPMethod) -> (URL) -> URLRequest {
        {
            var request = URLRequest(url: $0)
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    func addData(from model: Encodable) -> Request {
        {
            var request = $0
            do {
                request.httpBody = try JSONEncoder().encode(model)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
