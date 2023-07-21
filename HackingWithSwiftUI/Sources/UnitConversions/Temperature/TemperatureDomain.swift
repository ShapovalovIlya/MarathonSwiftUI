//
//  File.swift
//  
//
//  Created by User on 19.07.2023.
//

import Foundation
import Combine
import SwiftUDF

public struct TemperatureDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var inputValueType: TemperatureType
        public var outputValueType: TemperatureType
        public var inputTemperature: Double
        public var temperatureResult: String
        
        //MARK: - init(_:)
        public init(
            inputValueType: TemperatureType = .celsius,
            outputValueType: TemperatureType = .fahrenheit,
            inputTemperature: Double = .init()
        ) {
            self.inputValueType = inputValueType
            self.outputValueType = outputValueType
            self.inputTemperature = inputTemperature
            self.temperatureResult = "0"
        }
        
    }
    
    //MARK: - Actio
    public enum Action: Equatable {
        case setInputType(TemperatureType)
        case setOutputType(TemperatureType)
        case setInputTemperature(Double)
        case calculateTemperature
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setInputType(input):
            state.inputValueType = input
            return Just(.calculateTemperature)
                .eraseToAnyPublisher()
            
        case let .setOutputType(output):
            state.outputValueType = output
            return Just(.calculateTemperature)
                .eraseToAnyPublisher()
            
        case let .setInputTemperature(temperature):
            state.inputTemperature = temperature
            if state.inputTemperature.isZero {
                state.temperatureResult = "Result value"
            }
            return Just(.calculateTemperature)
                .eraseToAnyPublisher()
            
        case .calculateTemperature:
            state.temperatureResult = Measurement(
                value: state.inputTemperature,
                unit: state.inputValueType.unit)
            .converted(to: state.outputValueType.unit)
            .value
            .toUnitText(maximumFractionDigits: 1)
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self())
}
