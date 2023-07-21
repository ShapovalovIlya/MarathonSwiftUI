//
//  TimeDomain.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct TimeDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var inputTime: Double
        public var resultTime: String
        public var inputValueType: TimeType
        public var outputValueType: TimeType
        
        //MARK: - init(_:)
        public init(
            inputTime: Double = .init(),
            resultTime: String = "0",
            inputValueType: TimeType = .seconds,
            outputValueType: TimeType = .minutes
        ) {
            self.inputTime = inputTime
            self.resultTime = resultTime
            self.inputValueType = inputValueType
            self.outputValueType = outputValueType
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setInputType(TimeType)
        case setOutputType(TimeType)
        case setInputTime(Double)
        case computeValue
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setInputTime(time):
            state.inputTime = time
            if state.inputTime.isZero {
                state.resultTime = "Result value"
            }
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setInputType(type):
            state.inputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setOutputType(type):
            state.outputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case .computeValue:
            state.resultTime = Measurement(
                value: state.inputTime,
                unit: state.inputValueType.unit)
            .converted(to: state.outputValueType.unit)
            .value
            .toUnitText(maximumFractionDigits: 6)
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}
