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

public struct BookwormStorage {
    public var fetchStudents: () -> AnyPublisher<[Student], Error>
    
    public static var live: BookwormStorage {
        let storage = BookwormProvider()
        
        return .init(
            fetchStudents: storage.fetchStudents
        )
    }
}


private final class BookwormProvider {
    //MARK: - Private properties
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: String(describing: BookwormProvider.self)
    )
    private let container: NSPersistentContainer
    private let repository: CoreDataRepository<Student>
    
    //MARK: - init(_:)
    init() {
        guard
            let modelURL = Bundle.module.url(forResource: "Bookworm", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Unable to initialize CoreData model")
        }
        
        container = NSPersistentContainer(name: "Bookworm", managedObjectModel: model)
        repository = .init(context: container.viewContext)
        
        container.loadPersistentStores { _, error in
            if let error = error {
                self.logger.error("Failed to load: \(error.localizedDescription)")
            }
        }
        
        logger.debug(#function)
    }
    
    //MARK: - deinit
    deinit {
        logger.debug(#function)
    }
    
    //MARK: - Public methods
    func fetchStudents() -> AnyPublisher<[Student], Error> {
        logger.debug(#function)
        return repository.fetch()
    }
}
