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

public struct CoreDataClient {
    public var fetchStudents: () -> AnyPublisher<[Student], Error>
    
    public static var live: CoreDataClient {
        let storage = CoreDataStorage()
        
        return .init(fetchStudents: storage.fetchStudents)
    }
}

private final class CoreDataStorage {
    //MARK: - Private properties
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: CoreDataStorage.self)
    )
    private let container: NSPersistentContainer
    
    //MARK: - init(_:)
    init() {
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
        logger.debug("Initialized")
    }
    
    deinit {
        logger.debug("Deinitialized")
    }
    
    //MARK: - Public methods
    func fetchStudents() -> AnyPublisher<[Student], Error> {
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
