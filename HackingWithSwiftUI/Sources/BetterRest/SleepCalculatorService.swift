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
    
    public static func predictSleep(wakeUp: Date, sleep: Double, coffee: Int) -> AnyPublisher<Date, Error> {
        Future<Date, Error> { promise in
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
                    promise(.success(sleepTime))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
