//
//  BookwormStorage.swift
//
//
//  Created by Илья Шаповалов on 25.08.2023.
//

import Foundation
import Combine
import CoreData
import OSLog

public final class BookwormProvider {
    //MARK: - Private properties
    private let logger: Logger?
    private let container: NSPersistentContainer
    private let repository: CoreDataRepository<Student>
    
    //MARK: - init(_:)
    public init(
        persistentStoreDescriptions: [NSPersistentStoreDescription] = .init(),
        logger: Logger? = nil
    ) {
        guard
            let modelURL = Bundle.module.url(forResource: "Bookworm", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Unable to initialize CoreData model")
        }
        self.logger = logger
        container = NSPersistentContainer(name: "Bookworm", managedObjectModel: model)
        container.persistentStoreDescriptions = persistentStoreDescriptions
        repository = .init(context: container.viewContext)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                logger?.error("Failed to load: \(error.localizedDescription)")
            }
        }
        
        logger?.debug(#function)
    }
    
    //MARK: - deinit
    deinit {
        logger?.debug(#function)
    }
    
    //MARK: - Public methods
    public func fetchStudents() -> AnyPublisher<[Student], Error> {
        logger?.debug(#function)
        return repository.fetch()
    }
}
