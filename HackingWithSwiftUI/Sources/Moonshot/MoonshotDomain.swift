//
//  File.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import Foundation
import SwiftUDF
import Combine
import Shared
import AppDependencies
import OSLog

public struct MoonshotDomain: ReducerDomain {
    //MARK: - State
    public struct State {
        public var astronauts: [String: Astronaut]
        public var missions: [Mission]
        
        public init(
            astronauts: [String: Astronaut] = .init(),
            missions: [Mission] = .init()
        ) {
            self.astronauts = astronauts
            self.missions = missions
        }
    }
    
    //MARK: - Action
    public enum Action {
        case loadAstronauts
        case loadMissions
        case loadAstronautsResponse(Result<[String: Astronaut], Error>)
        case loadMissionsResponse(Result<[Mission], Error>)
    }
    
    //MARK: - Logger
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    
    //MARK: - Dependencies
    private let getAstronauts: (String) -> AnyPublisher<[String: Astronaut], Error>
    private let getMissions: (String) -> AnyPublisher<[Mission], Error>
    
    //MARK: - init(_:)
    public init(
        getAstronauts: @escaping (String) -> AnyPublisher<[String: Astronaut], Error> = FileManager.shared.getData,
        getMissions: @escaping (String) -> AnyPublisher<[Mission], Error> = FileManager.shared.getData
    ) {
        self.getAstronauts = getAstronauts
        self.getMissions = getMissions
        
        logger.debug("Initialized.")
    }
    
    //MARK: - Reducer
    public func reduce(_ state: inout State, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case .loadAstronauts:
            return getAstronauts("astronauts.json")
                .map(mapToSuccessLoadAstronautsAction(_:))
                .catch(catchToFailLoadAstronautsAction(_:))
                .eraseToAnyPublisher()
            
        case .loadMissions:
            return getMissions("missions.json")
                .map(mapToSuccessLoadMissionsAction(_:))
                .catch(catchToFailLoadMissionsAction(_:))
                .eraseToAnyPublisher()
            
        case let .loadAstronautsResponse(.success(astronauts)):
            state.astronauts = astronauts
            
        case let .loadMissionsResponse(.success(missions)):
            state.missions = missions
            
        case let .loadAstronautsResponse(.failure(error)):
            logger.error("Fail to load astronauts: \(error.localizedDescription)")
            
        case let .loadMissionsResponse(.failure(error)):
            logger.error("Fail to load missions: \(error.localizedDescription)")
        }
        
        return Empty().eraseToAnyPublisher()
    }
    
}

private extension MoonshotDomain {
    func mapToSuccessLoadAstronautsAction(_ astronauts: [String: Astronaut]) -> Action {
        .loadAstronautsResponse(.success(astronauts))
    }
    
    func mapToSuccessLoadMissionsAction(_ missions: [Mission]) -> Action {
        .loadMissionsResponse(.success(missions))
    }
    
    func catchToFailLoadAstronautsAction(_ error: Error) -> Just<Action> {
        Just(.loadAstronautsResponse(.failure(error)))
    }
    
    func catchToFailLoadMissionsAction(_ error: Error) -> Just<Action> {
        Just(.loadMissionsResponse(.failure(error)))
    }
}

extension MoonshotDomain.Action: Equatable {
    public static func == (lhs: MoonshotDomain.Action, rhs: MoonshotDomain.Action) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

//MARK: - Store
extension MoonshotDomain {
    //MARK: - Preview store
    static let previewStore = Store(
        state: Self.State(),
        reducer: Self(
            getAstronauts: { _ in
                Just(Astronaut.sample)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            getMissions: { _ in
                Just(Mission.sample)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    )
    
    //MARK: - Live store
    static let liveStore = Store(
        state: Self.State(),
        reducer: Self()
    )
}
