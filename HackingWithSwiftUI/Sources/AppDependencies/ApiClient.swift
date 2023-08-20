//
//  ApiClient.swift
//
//
//  Created by Илья Шаповалов on 20.08.2023.
//

import Foundation
import SwiftFP
import Combine

public enum ApiClient {
    typealias Request = (URLRequest) -> URLRequest
    typealias DataTaskPublisher = (URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
    
}

private extension ApiClient {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func setHTTP(method: HTTPMethod) -> Request {
        {
            var request = $0
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    func setURL(string: String) -> Request {
        {
            var request = $0
            request.url = URL(string: string)
            return request
        }
    }
    
    func eraseToPublisher() -> DataTaskPublisher {
        {
            URLSession.DataTaskPublisher(request: $0, session: .shared)
                .mapError { $0 }
                .eraseToAnyPublisher()
        }
    }
}
