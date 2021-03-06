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
        
        if visitMode {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(turnBack(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.gray
        }
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func backHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
}
