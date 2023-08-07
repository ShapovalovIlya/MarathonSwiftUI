//
//  NavigationCollection.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 07.08.2023.
//

import SwiftUI

public struct NavigationCollection<Collection, Destination, Label>: View where Collection: RandomAccessCollection,
                                                                               Collection.Element: Identifiable,
                                                                               Destination: View,
                                                                               Label : View {
    let data: Collection
    let destination: (Collection.Element) -> Destination
    let label: (Collection.Element) -> Label
    
    public var body: some View {
        ForEach(data) { element in
            NavigationLink {
                destination(element)
            } label: {
                label(element)
            }
            
        }
    }
    
    public init(
        data: Collection,
        destination: @escaping (Collection.Element) -> Destination,
        label: @escaping (Collection.Element) -> Label
    ) {
        self.data = data
        self.destination = destination
        self.label = label
    }
}
