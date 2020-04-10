//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/10/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

class MinesweeperViewController: UIViewController {

    @IBOutlet weak var tile: UITileView! {
        didSet {
            tile.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(MinesweeperViewController.handleTap(gesture:))))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            print("Tap ended")
            if let view = gesture.view as? UITileView {
                // handle tap
                view.state = UITileView.TileState.BOMB
            }
        default:
            break
        }
    }


}

