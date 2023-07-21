//
//  VolumeDomain.swift
//  
//
//  Created by User on 20.07.2023.
//

import Foundation
import SwiftUDF
import Combine

public struct VolumeDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var inputVolume: Double
        public var resultVolume: String
        public var inputValueType: VolumeType
        public var outputValueType: VolumeType
        
        //MARK: - init(_:)
        public init(
            inputVolume: Double = .init(),
            resultVolume: String = "0",
            inputValueType: VolumeType = .milliliters,
            outputValueType: VolumeType = .liters
        ) {
            self.inputVolume = inputVolume
            self.resultVolume = resultVolume
            self.inputValueType = inputValueType
            self.outputValueType = outputValueType
        }
    }
    
    //MARK: - Action
    public enum Action: Equatable {
        case setInputType(VolumeType)
        case setOutputType(VolumeType)
        case setInputVolume(Double)
        case computeValue
    }
    
    //MARK: - init(_:)
    public init() {}
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case let .setInputVolume(volume):
            state.inputVolume = volume
            if state.inputVolume.isZero {
                state.resultVolume = "Result value"
            }
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setInputType(type):
            state.inputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case let .setOutputType(type):
            state.outputValueType = type
            return Just(.computeValue).eraseToAnyPublisher()
            
        case .computeValue:
            state.resultVolume = Measurement(
                value: state.inputVolume,
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
