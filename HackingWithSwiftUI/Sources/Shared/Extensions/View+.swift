//
//  View+.swift
//  
//
//  Created by User on 19.07.2023.
//

import SwiftUI

public extension View {
    @inlinable func cornersRadius(
        _ radius: CGFloat,
        corners: UIRectCorner = .allCorners
    ) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
