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
    }
    
    @IBAction func removeColumn(_ sender: Any) {
        if let col = gameBoard.arrangedSubviews.last as? UIStackView {
            for tile in col.arrangedSubviews {
                col.removeArrangedSubview(tile)
                tile.removeFromSuperview()
            }
            gameBoard.removeArrangedSubview(col)
            col.removeFromSuperview()
        }
    }
    
    @objc func updateOrientation() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            // landscape
        } else {
            // default to portrait
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
            }
        default:
            break
        }
    }


}

