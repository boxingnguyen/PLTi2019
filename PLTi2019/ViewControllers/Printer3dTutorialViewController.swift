//
//  Printer3dTutorialViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/18/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import SwiftGif

class Printer3dTutorialViewController: UIViewController {
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var definition3dPrinting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
   
    @IBAction func backHome(_ sender: Any) {
        let stboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = stboard.instantiateViewController(withIdentifier: "homeVC")
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func setupView() {
        gifView.loadGif(asset: "3dprinting")
        self.navigationItem.title = "3D Printing Tutorial"
        let boldText  = "3D printing "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "is any of various processes in which material is joined or solidified under computer control to create a three-dimensional object, with material being added together, typically layer by layer."
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        self.definition3dPrinting.attributedText = attributedString
    }
}
