//
//  SignUpViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/28/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let haveAccountButton: UIButton = {
        let color = UIColor.init(red: 89, green: 156, blue: 120, alpha: 11)
        let font = UIFont.systemFont(ofSize: 16)
        let h = UIButton(type: .system)
        h.backgroundColor = GREEN_THEME
        
        let attributedTitle = NSMutableAttributedString(string:
            "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor:
                color, NSAttributedString.Key.font : font ])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: font]))
        
        h.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        h.setAttributedTitle(attributedTitle, for: .normal)
        return h
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GREEN_THEME
        setupHaveAccountButton()
        
        username.textColor = .white
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        username.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
        
        email.textColor = .white
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
        
        password.isSecureTextEntry = true
        password.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        btnSignUp.layer.cornerRadius = 10
    }
    
    @objc func signInAction() {
        navigationController?.popViewController(animated: true)
        print("abc")
    }
    
    fileprivate func setupHaveAccountButton() {
        view.addSubview(haveAccountButton)
        
        haveAccountButton.anchors(top: nil, topPad: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  bottomPad: 30, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor,
                                  rightPad: 0, height: 33, width: 0)
    }
}
