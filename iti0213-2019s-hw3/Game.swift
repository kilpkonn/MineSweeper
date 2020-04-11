//
//  Game.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/11/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import Foundation

class Game {
    
    private var bombs: [(Int, Int)] = []
    private var flags: [(Int, Int)] = []
    private var rows: Int = 0
    private var cols: Int = 0
    var opened: [[Bool]] = []
    
    init(rows: Int, cols: Int, level: Int) {
        opened = Array(repeating: Array(repeating: false, count: cols), count: rows)
        self.rows = rows
        self.cols = cols
        let bombCount = Int(0.1 * Double(level * rows * cols))
        for _ in 0...bombCount {
            var r: Int
            var c: Int
            repeat {
                r = Int.random(in: 0...rows)
                c = Int.random(in: 0...cols)
            } while (bombs.contains(where: {$0 == (r, c)}))
            bombs.append((r, c))
        }
    }
    
    func isBomb(row: Int, col: Int) -> Bool {
        return bombs.contains(where: {$0 == (row, col)})
    }
    
    func isFlag(row: Int, col: Int) -> Bool {
        return flags.contains(where: {$0 == (row, col)})
    }
    
    func addFlag(row: Int, col: Int) {
        flags.append((row, col))
    }
    
    func removeFlag(row: Int, col: Int) {
        flags.removeAll(where: {$0 == (row, col)})
    }
    
    func openTile(row: Int, col: Int) {
        opened[row][col] = true
        for r in -1...1 {
            for c in -1...1 {
                if (!(r == 0 && c == 0) && row + r >= 0 && col + c >= 0 && row + r < rows && col + c < cols) {
                    if (!opened[row + r][col + c]) {
                        openTile(row: row + r, col: col + c)
                    }
                }
            }
        }
    }
    
}
