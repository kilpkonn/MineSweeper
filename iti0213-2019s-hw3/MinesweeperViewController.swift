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
    @IBOutlet weak var minesCount: UITextField!
    @IBOutlet weak var timer: UITextField!
    
    private var gameSession: Game?
    private var level: Int = 1
    private var timerLoop: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOrientation()
        minesCount.text = "\(gameSession?.bombCount ?? 0) 💣"
        timerLoop = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.update()})
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @IBAction func selectLevel1(_ sender: Any) {
        level = 1
        startGame()
    }
    @IBAction func selectLevel2(_ sender: Any) {
        level = 2
        startGame()
    }
    @IBAction func selectLevel3(_ sender: Any) {
        level = 3
        startGame()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // remove?
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateOrientation()
    }
    
    func update() {
        timer.text  = "\(Int(gameSession?.getSecondsElapsed() ?? 0) / 60):\(String(format:"%02d",Int(gameSession?.getSecondsElapsed() ?? 0) % 60))"
    }
    
    private func startGame() {
        gameSession = Game(rows: gameBoard.arrangedSubviews.count,
                           cols: (gameBoard.arrangedSubviews.first as? UIStackView)!.arrangedSubviews.count,
                           level: level)
        
        minesCount.text = "\(gameSession?.bombCount ?? 0) 💣"
        updateTiles()
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
                addGestureRecognizers(tile: tile)
                columnStack.addArrangedSubview(tile)
            }
        }
        startGame()
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
                addGestureRecognizers(tile: tile)
                columnStack.addArrangedSubview(tile)
            }
        }
        gameBoard.addArrangedSubview(columnStack)
        
        startGame()
        updateTiles()
    }
    
    private func addGestureRecognizers(tile: UITileView) {
        let singleTapRec = UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleTap(gesture:)))
        tile.addGestureRecognizer(singleTapRec)
        let doubleTapRec = UITapGestureRecognizer(target: self, action: #selector(MinesweeperViewController.handleDoubleTap(gesture:)))
        doubleTapRec.numberOfTapsRequired = 2
        tile.addGestureRecognizer(doubleTapRec)
        singleTapRec.require(toFail: doubleTapRec)
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
        startGame()
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
            
            startGame()
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
                            if ((gameSession?.isBomb(row: tile.positionX, col: tile.positionY)) ?? false) {
                                if (gameSession?.isFlag(row: tile.positionX, col: tile.positionY) ?? false) {
                                    tile.state = .BAIT
                                } else {
                                    tile.state = .BOMB
                                }
                            } else {
                                tile.state = .NUMBER
                                tile.closeBombsCount = gameSession?.getCloseBombsCount(row: tile.positionX, col: tile.positionY) ?? 0
                            }
                        } else if (gameSession?.isFlag(row: tile.positionX, col: tile.positionY) ?? false) {
                            tile.state = .FLAG
                        } else {
                            tile.state = .HIDDEN
                        }
                    }
                }
            }
        }
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            print("Tap ended")
            if let view = gesture.view as? UITileView {
                // handle tap
                view.state = UITileView.TileState.BOMB
                print("Tap at (\(view.positionX), \(view.positionY))")
                gameSession?.openTile(row: view.positionX, col: view.positionY)
                updateTiles()
            }
        }
    }
    
    @objc private func handleDoubleTap(gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            print("Tap ended")
            if let view = gesture.view as? UITileView {
                // handle tap
                view.state = UITileView.TileState.BOMB
                print("Double Tap at (\(view.positionX), \(view.positionY))")
                gameSession?.addFlag(row: view.positionX, col: view.positionY)
                updateTiles()
            }
        }
    }


}

