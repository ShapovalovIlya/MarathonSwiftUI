//
//  Endpoint.swift
//
//
//  Created by Илья Шаповалов on 20.08.2023.
//

import Foundation

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "reqres.in/api"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Unable to create url from \(components)")
        }
        return url
    }
    
    init(
        path: String,
        queryItems: [URLQueryItem] = .init()
    ) {
        self.path = path
        self.queryItems = queryItems
    }
    
    public static let sendOrder: Self = .init(path: "cupcakes")
}
