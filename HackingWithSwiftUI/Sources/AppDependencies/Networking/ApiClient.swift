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
    
}
