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
    var bombCount: Int = 0
    
    private let start = Date()
    private var gameTime: Double = -1
    
    var opened: [[Bool]] = []
    var lost: Bool = false
    
    init(rows: Int, cols: Int, level: Float) {
        opened = Array(repeating: Array(repeating: false, count: cols), count: rows)
        self.rows = rows
        self.cols = cols
        bombCount = Int(level * Float(rows * cols)) + 1
        for _ in 0..<bombCount {
            var r: Int
            var c: Int
            repeat {
                r = Int.random(in: 0..<rows)
                c = Int.random(in: 0..<cols)
            } while (bombs.contains(where: {$0 == (r, c)}))
            bombs.append((r, c))
        }
    }
    
    func getSecondsElapsed() -> Double {
        if gameTime > 0 {
            return gameTime
        }
        return -start.timeIntervalSinceNow
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
    
    func isGameOver() -> Bool {
        var closed = 0
        for row in opened {
            for tile in row {
                if (!tile) {
                    closed = closed + 1
                }
            }
        }
        let gameOver: Bool = closed <= bombCount || lost
        
        if gameOver {
            gameTime = getSecondsElapsed()
        }
        
        return gameOver
    }
    
    func getCloseBombsCount(row: Int, col: Int) -> Int {
        var count: Int = 0
        for r in -1...1 {
            for c in -1...1 {
                if (row + r >= 0 && col + c >= 0 && row + r < rows && col + c < cols) {
                    if (isBomb(row: row + r, col: col + c)) {
                        count += 1
                    }
                }
            }
        }
        return count
    }
    
    func getCloseFlagsCount(row: Int, col: Int) -> Int {
        var count: Int = 0
        for r in -1...1 {
            for c in -1...1 {
                if (row + r >= 0 && col + c >= 0 && row + r < rows && col + c < cols) {
                    if (isFlag(row: row + r, col: col + c)) {
                        count += 1
                    }
                }
            }
        }
        return count
    }
    
    func openTile(row: Int, col: Int) {
        opened[row][col] = true
        if isBomb(row: row, col: col) {
            lost = true
            gameTime = getSecondsElapsed()
        }
        
        isGameOver() // Check if u got baited
        
        if (getCloseBombsCount(row: row, col: col) > getCloseFlagsCount(row: row, col: col)) {
            return
        }
        
        
        for r in -1...1 {
            for c in -1...1 {
                if (!(r == 0 && c == 0) && row + r >= 0 && col + c >= 0 && row + r < rows && col + c < cols) {
                    if (!opened[row + r][col + c] && !isFlag(row: row + r, col: col + c)) {
                        openTile(row: row + r, col: col + c)
                    }
                }
            }
        }
    }
    
}
