//
//  CoreDataClient.swift
//
//
//  Created by Илья Шаповалов on 25.08.2023.
//

import Foundation
import Combine
import CoreData
import OSLog

public final class CoreDataClient {
    //MARK: - Private properties
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: CoreDataClient.self)
    )
    private let container: NSPersistentContainer
    
    //MARK: - Shared
    public static let shared = CoreDataClient()
    
    //MARK: - init(_:)
    private init() {
        guard
            let modelURL = Bundle.module.url(forResource: "Bookworm", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Unable to initialize CoreData model")
        }
        
        container = NSPersistentContainer(name: "Bookworm", managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                self.logger.error("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Public methods
    public func fetchStudents() -> AnyPublisher<[Student], Error> {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        return Future<[Student], Error>{ [weak self] promise in
            guard let self else { return }
            do {
                let students = try self.container.viewContext.fetch(fetchRequest)
                promise(.success(students))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
