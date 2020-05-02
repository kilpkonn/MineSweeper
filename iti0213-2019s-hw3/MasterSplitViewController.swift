//
//  MasterSplitViewController.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/20/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

class MasterSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }

}
