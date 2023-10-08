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
    private let logger: Logger?
    private let session: URLSession
    typealias Request = (URLRequest) -> URLRequest
    public typealias ResponsePublisher = AnyPublisher<(data: Data, response: URLResponse), Error>
    
    public init(
        session: URLSession = .shared,
        logger: Logger? = nil
    ) {
        self.session = session
        self.logger = logger
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
        Box(url)
            .map(makeRequest(.GET))
            .flatMap(dataTaskPublisher(session: session))
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    
    public func postRequest(url: URL, content: Encodable) -> ResponsePublisher {
        Box(url)
            .map(makeRequest(.POST))
            .map(addData(from: content))
            .flatMap(dataTaskPublisher(session: session))
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
