//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/27/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UITileView.isDarkTheme ? UIColor.lightGray : UIColor.white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
