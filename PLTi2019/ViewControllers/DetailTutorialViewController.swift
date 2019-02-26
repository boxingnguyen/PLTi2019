//
//  DetailTutorialViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 2/18/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import YouTubeiOSPlayerHelper

class DetailTutorialViewController: UIViewController {
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step1Body: UITextView!
    @IBOutlet weak var step2Body: UITextView!
    @IBOutlet weak var tutVideo: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.navigationItem.title = "3D Printing Tutorial"
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        step1Label.attributedText = NSAttributedString(string: "Step1:", attributes: underlineAttribute)
        step2Label.attributedText = NSAttributedString(string: "Step2:", attributes: underlineAttribute)
        step3Label.attributedText = NSAttributedString(string: "Step3:", attributes: underlineAttribute)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        self.tutVideo.load(withVideoId: "JxSeMGbkWYE")
    }
    

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
