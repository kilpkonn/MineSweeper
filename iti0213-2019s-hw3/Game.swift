//
//  Game.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/11/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import Foundation

class Game {
    
    enum Tile {
        case empty
        case bomb
        case flag
    }
    private var board: [[Tile]] = []
    private var openedBoard: [[Bool]] = []
    
    init(rows: Int, cols: Int, level: Int) {
        for y in 0..<rows {
            var row: [Tile] = []
            var openRow: [Bool] = []
            for x in 0..<cols {
                row.append(.empty)
                openRow.append(false)
            }
            board.append(row)
            openedBoard.append(openRow)
        }
        
        for _ in 0..<(level / 10 * rows * cols) {
            var r: Int
            var c: Int
            repeat {
                r = Int.random(in: 0...rows)
                c = Int.random(in: 0...cols)
            } while (board[r][c] != .empty)
        }
    }
    
}
