//
//  LenghtDomain.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct LenghtDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var inputLenght: Double
        public var resultLenght: String
        public var inputValueType: LengthType
        public var outputValueType: LengthType
        
        //MARK: - init(_:)
        public init(
            inputLenght: Double = .init(),
            resultLenght: String = "0",
            inputValueType: LengthType = .meters,
            outputValueType: LengthType = .kilometers
        ) {
            self.inputLenght = inputLenght
            self.resultLenght = resultLenght
            self.inputValueType = inputValueType
            self.outputValueType = outputValueType
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setInputType(LengthType)
        case setOutputType(LengthType)
        case setInputLenght(Double)
        case computeValue
    }
    
    //MARK: - init(_)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setInputType(type):
            state.inputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setOutputType(type):
            state.outputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setInputLenght(lenght):
            state.inputLenght = lenght
            if state.inputLenght.isZero {
                state.resultLenght = "Result value"
            }
            return Just(.computeValue).eraseToAnyPublisher()
            
        case .computeValue:
            state.resultLenght = Measurement(
                value: state.inputLenght,
                unit: state.inputValueType.unit)
            .converted(to: state.outputValueType.unit)
            .value
            .toUnitText(maximumFractionDigits: 3)
        }
        return Empty().eraseToAnyPublisher()
    }
    
    //MARK: - PreviewStore
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}
