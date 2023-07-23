//
//  SleepCalculatorService.swift
//  
//
//  Created by Илья Шаповалов on 23.07.2023.
//

import CoreML
import Foundation
import Combine

public struct SleepCalculatorService {
    public var predictSleep: (_ wakeUp: Date, _ sleep: Double, _ coffee: Int) -> AnyPublisher<String, Error>
    
    public static let live = Self(
        predictSleep: { wakeUp, sleep, coffee in
            Future<String, Error> { promise in
                DispatchQueue.main.async {
                    do {
                        let config = MLModelConfiguration()
                        let model = try SleepCalculator(configuration: config)
                        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                        let hour = (components.hour ?? 0) * 60 * 60
                        let minutes = (components.minute ?? 0) * 60
                        let prediction = try model.prediction(
                            wake: Double(hour + minutes),
                            estimatedSleep: sleep,
                            coffee: Double(coffee)
                        )
                        let sleepTime = wakeUp - prediction.actualSleep
                        let sleepDate = sleepTime.formatted(date: .omitted, time: .shortened)
                        promise(.success(sleepDate))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        })
}
