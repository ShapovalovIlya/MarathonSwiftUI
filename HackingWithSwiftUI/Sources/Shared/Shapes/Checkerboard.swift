//
//  Checkerboard.swift
//  
//
//  Created by Илья Шаповалов on 15.08.2023.
//

import SwiftUI

public struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    public var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(Double(rows), Double(columns)) }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
    }
}

#Preview {
    Checkerboard(rows: 4, columns: 4)
}
