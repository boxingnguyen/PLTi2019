//
//  LoginViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/25/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBAction func btnLoginTouch(_ sender: Any) {
        if let name = username.text, let pass = password.text {
            
            Api.shared.login(username: name, password: pass, success: { (deptrai) in
                print(deptrai)
                
                let stboard = UIStoryboard.init(name: "Main", bundle: nil)
                let bookshelf = stboard.instantiateViewController(withIdentifier: "bookshelfVC") as! BookshelfViewController
                
                self.navigationController?.pushViewController(bookshelf, animated: true)
                print("xxx")
            }) { (Error) in
                print("a du")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 10
        view.backgroundColor = GREEN_THEME
        navigationController?.isNavigationBarHidden = true

        username.textColor = .white
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        username.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
        
        password.isSecureTextEntry = true
        password.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: .white)
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let color = UIColor.rgb(r: 89, g: 156, b: 120)
        let font = UIFont.systemFont(ofSize: 17)
        
        let attributedTitle = NSMutableAttributedString(string:
            "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor:
                color, NSAttributedString.Key.font : font ])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: font]))

        self.hideKeyboardWhenTappedAround()
        self.username.delegate = self
        self.password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}
