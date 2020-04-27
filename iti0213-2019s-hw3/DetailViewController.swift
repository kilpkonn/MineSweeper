//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/10/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tileSizeTextField: UITextField!
    @IBOutlet weak var bombIconTextField: UITextField!
    @IBOutlet weak var flagIconTextField: UITextField!
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        bombIconTextField.text = UITileView.bombIcon
        flagIconTextField.text = UITileView.flagIcon
        themeSwitch.isOn = UITileView.isDarkTheme
    }

    @IBAction func onLevel1TouchUpInside(_ sender: Any) {
        difficultySlider.value = 0.1
    }
    @IBAction func onLevel2TouchUpInside(_ sender: Any) {
        difficultySlider.value = 0.2
    }
    @IBAction func onLevel3TouchUpInside(_ sender: Any) {
        difficultySlider.value = 0.3
    }
    @IBAction func onPlaygroundColorChenged(_ sender: UISwitch) {
        UITileView.isDarkTheme = sender.isOn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UITileView.bombIcon = bombIconTextField.text ?? UITileView.bombIcon
        UITileView.flagIcon = flagIconTextField.text ?? UITileView.flagIcon
    }
}
