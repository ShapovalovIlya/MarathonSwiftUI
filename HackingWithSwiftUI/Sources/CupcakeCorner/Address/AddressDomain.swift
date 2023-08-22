//
//  AddressDomain.swift
//
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct AddressDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        public var name: String
        public var streetAddress: String
        public var city: String
        public var zip: String
        
        public var hasValidAddress: Bool {
            if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
                return false
            }
            return true
        }
        
        public init(
            name: String = .init(),
            streetAddress: String = .init(),
            city: String = .init(),
            zip: String = .init()
        ) {
            self.name = name
            self.streetAddress = streetAddress
            self.city = city
            self.zip = zip
        }
    }
    
    //MARK: - Action
    public enum Action {
        case setName(String)
        case setStreetAddress(String)
        case setCity(String)
        case setZip(String)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setName(name):
            state.name = name
            
        case let .setStreetAddress(address):
            state.streetAddress = address
            
        case let .setCity(city):
            state.city = city
            
        case let .setZip(zip):
            state.zip = zip
        }
        
        return empty()
    }
    
    //MARK: - PreviewStore
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
