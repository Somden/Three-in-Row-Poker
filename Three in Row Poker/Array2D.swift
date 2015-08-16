//
//  Array2D.swift
//  Three in Row Poker
//
//  Created by Denis Somok on 09.07.15.
//  Copyright (c) 2015 Denis Somok. All rights reserved.
//

import Foundation

class Array2D<T> {
    let columns: Int
    let rows: Int
    
    private var array: [T?]
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: columns * rows, repeatedValue: nil)
    }
    
    func toFlatArray() -> Array<T?> {
        return array
    }
    
    subscript(row: Int, column: Int) -> T? {
        get {
            return self.array[(row * self.columns) + column]
        }
        
        set {
            self.array[(row * self.columns) + column] = newValue
        }
    }
}
