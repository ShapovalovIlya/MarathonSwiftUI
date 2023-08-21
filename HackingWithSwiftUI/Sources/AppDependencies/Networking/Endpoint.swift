//
//  Endpoint.swift
//
//
//  Created by Илья Шаповалов on 20.08.2023.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.queryItems = queryItems
        
        return components.url
    }
    
    static func search(matching query: String) -> Endpoint {
        .init(
            path: "/search/repositories",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                
            ])
    }
}
