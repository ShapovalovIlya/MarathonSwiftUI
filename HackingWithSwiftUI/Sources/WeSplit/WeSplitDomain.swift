//
//  Domain.swift
//  WeSplit
//
//  Created by User on 16.07.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct WeSplitDomain: ReducerDomain {
    //MARK: - State
    public struct State: Equatable {
        var checkAmount: Double
        var numberOfPeople: Int
        var tip: TipPercent
        
        var totalPerPerson: Double {
            return billWithTips / Double(numberOfPeople + 2)
        }
        
        var billWithTips: Double {
            checkAmount + (checkAmount * tip.rawValue)
        }
        
        public init() {
            checkAmount = .init()
            numberOfPeople = .init()
            tip = .ten
        }
    }
    
    //MARK: - Actions
    public enum Action: Equatable {
        case setCheckAmount(Double)
        case setNumberOfPeople(Int)
        case setTip(TipPercent)
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setCheckAmount(newCheck):
            state.checkAmount = newCheck
            
        case let .setNumberOfPeople(numberOfPeople):
            state.numberOfPeople = numberOfPeople
            
        case let .setTip(tip):
            state.tip = tip
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview Store
    public static let previewStore = Store(
        state: Self.State(),
        reducer: Self.init())
}
