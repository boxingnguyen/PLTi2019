//
//  VisitViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/19/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class VisitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.navigationItem.title = "Let's go around!"
        let yourBackImage = UIImage(named: "home")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
    }
}
