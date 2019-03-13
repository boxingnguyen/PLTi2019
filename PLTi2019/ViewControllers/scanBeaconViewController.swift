//
//  scanBeaconViewController.swift
//  PLTi2019
//
//  Created by Nguyen Quyen Anh on 3/13/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import Pulsator

class scanBeaconViewController: UIViewController {
    @IBOutlet weak var viewScan: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let pulsator = Pulsator()
        
        view.layer.addSublayer(pulsator)
        view.layer.position = view.center
        pulsator.position = view.layer.position
        
        pulsator.start()
        pulsator.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
        pulsator.numPulse = 3
        pulsator.radius = 140.0
        pulsator.animationDuration = 5.0
        
    }
}
