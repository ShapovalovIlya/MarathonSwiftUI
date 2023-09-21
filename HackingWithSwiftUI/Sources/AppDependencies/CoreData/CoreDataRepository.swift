//
//  CoreDataRepository.swift
//
//
//  Created by Илья Шаповалов on 21.09.2023.
//

import Foundation
import CoreData
import Combine

struct CoreDataRepository<Entity: NSManagedObject> {
    //MARK: - Private properties
    private let context: NSManagedObjectContext
    
    //MARK: - init(_:)
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - fetch(sortDescriptors:predicate:) -> AnyPublisher<[Entity], Error>
    func fetch(
        sortDescriptors: [NSSortDescriptor] = .init(),
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let result = try context.fetch(request) as! [Entity]
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - object(_:) -> AnyPublisher<Entity, Error>
    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    guard let entity = try? context.existingObject(with: id) as? Entity else {
                        promise(.failure(CocoaError(.fileNoSuchFile)))
                        return
                    }
                    promise(.success(entity))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - add(_: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error>
    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - update(_:) -> AnyPublisher<Entity, Error>
    func update(_ entity: Entity) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - delete(_:) -> AnyPublisher<Entity, Error>
    func delete(_ entity: Entity) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        context.delete(entity)
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
        
}
    
