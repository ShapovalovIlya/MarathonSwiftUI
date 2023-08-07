//
//  AtomicCollection.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
public struct AtomicCollection<C> where C: Collection,
                                        C: Sequence,
                                        C: RandomAccessCollection,
                                        C: RangeReplaceableCollection {
    private let lock = NSLock()
    private var collection: C
    
    public var wrappedValue: C {
        get { collection }
        set {
            lock.lock()
            collection = newValue
            lock.unlock()
        }
    }
    
    public init(_ collection: C) {
        self.collection = collection
    }
    
    public subscript<T>(dynamicMember writableKeyPath: WritableKeyPath<C, T>) -> T {
        wrappedValue[keyPath: writableKeyPath]
    }
}
