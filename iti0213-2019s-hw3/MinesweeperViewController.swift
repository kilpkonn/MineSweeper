//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/10/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

class MinesweeperViewController: UIViewController {

    @IBOutlet weak var gameBoard: UIStackView!
    
    private var gameSession: Game?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOrientation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // remove?
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateOrientation()
    }
    
    private func createColumnStack() -> UIStackView {
        let columnStack = UIStackView()
        columnStack.axis = .vertical
        columnStack.alignment = .fill
        columnStack.distribution = .fillEqually
        columnStack.spacing = 0
        return columnStack
    }
    
    @IBAction func addRow(_ sender: Any) {
        if (gameBoard.arrangedSubviews.count == 0) {
            let columnStack = createColumnStack()
            gameBoard.addArrangedSubview(columnStack)
        }
        
        for (i, subView) in gameBoard.arrangedSubviews.enumerated() {
            if let columnStack = subView as? UIStackView {
                let tile = UITileView(frame: CGRect.zero, x: i, y: columnStack.arrangedSubviews.count)
                tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:))))
                columnStack.addArrangedSubview(tile)
            }
        }
        gameSession = Game(rows: gameBoard.arrangedSubviews.count,
                           cols: (gameBoard.arrangedSubviews.first as? UIStackView)!.arrangedSubviews.count,
                           level: 3)
        updateTiles()
    }
    
    @IBAction func addColumn(_ sender: Any) {
        if (gameBoard.arrangedSubviews.count == 0) {
            addRow(sender)
            return
        }
        let columnStack = createColumnStack()
    
        
        if let firstColView = gameBoard.arrangedSubviews.first as? UIStackView {
            let rowCount = firstColView.arrangedSubviews.count
            for y in 0..<rowCount {
                let tile = UITileView(frame: CGRect.zero, x: gameBoard.arrangedSubviews.count, y: y)
                tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:))))
                columnStack.addArrangedSubview(tile)
            }
        }
        gameBoard.addArrangedSubview(columnStack)
        
        gameSession = Game(rows: gameBoard.arrangedSubviews.count,
        cols: columnStack.arrangedSubviews.count,
        level: 3)
        updateTiles()
    }
    
    @IBAction func removeRow(_ sender: Any) {
        for col in gameBoard.arrangedSubviews {
            if let colStack = col as? UIStackView {
                if let tile = colStack.arrangedSubviews.last {
                    colStack.removeArrangedSubview(tile)
                    tile.removeFromSuperview()
                }
            }
        }
        gameSession = Game(rows: gameBoard.arrangedSubviews.count,
                           cols: (gameBoard.arrangedSubviews.first as? UIStackView)!.arrangedSubviews.count,
                           level: 3)
        updateTiles()
    }
    
    @IBAction func removeColumn(_ sender: Any) {
        if let col = gameBoard.arrangedSubviews.last as? UIStackView {
            for tile in col.arrangedSubviews {
                col.removeArrangedSubview(tile)
                tile.removeFromSuperview()
            }
            gameBoard.removeArrangedSubview(col)
            col.removeFromSuperview()
            
            gameSession = Game(rows: gameBoard.arrangedSubviews.count,
                               cols: col.arrangedSubviews.count,
                               level: 3)
            updateTiles()
        }
    }
    
    @objc func updateOrientation() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            // landscape
        } else {
            // default to portrait
        }
    }
    
    private func updateTiles() {
        for row in gameBoard.arrangedSubviews {
            if let rowStack = row as? UIStackView {
                for col in rowStack.arrangedSubviews {
                    if let tile = col as? UITileView {
                        if (gameSession?.opened[tile.positionX][tile.positionY] ?? false) {
                            if ((gameSession?.isBomb(row: tile.positionX, col: tile.positionY)) ?? true) {
                                tile.state = .BOMB // todo bait bombs
                            } else if (gameSession?.isFlag(row: tile.positionX, col: tile.positionY) ?? false) {
                                tile.state = .FLAG
                            } else {
                                tile.state = .NUMBER
                                tile.closeBombsCount = gameSession?.getCloseBombsCount(row: tile.positionX, col: tile.positionY) ?? 0
                            }
                        } else {
                            tile.state = .HIDDEN
                        }
                    }
                }
            }
        }
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            print("Tap ended")
            if let view = gesture.view as? UITileView {
                // handle tap
                view.state = UITileView.TileState.BOMB
                print("Tap at (\(view.positionX), \(view.positionY))")
                gameSession?.openTile(row: view.positionX, col: view.positionY)
                updateTiles()
            }
        default:
            break
        }
    }


}

