//
//  AnyTransition+.swift
//
//  Created by Илья Шаповалов on 30.07.2023.
//

import SwiftUI

public extension AnyTransition {
    static var pivot: Self {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}
