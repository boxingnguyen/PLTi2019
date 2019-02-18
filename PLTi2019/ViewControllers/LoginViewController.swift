//
//  LoginViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/25/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
//import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func btnLoginTouch(_ sender: Any) {
        if let name = username.text, let pass = password.text {
            Api.shared.login(username: name, password: pass, success: { (deptrai) in
                // deptrai is variable store user information
                let stboard = UIStoryboard.init(name: "Main", bundle: nil)
                let bookshelf = stboard.instantiateViewController(withIdentifier: "bookshelfVC") as! BookshelfViewController
                
                if name.isEmpty || pass.isEmpty {
                    self.errorLabel.isHidden = false
                    return
                }
                
                self.errorLabel.isHidden = true
                let userDefaults = UserDefaults.standard
                let decodedUser  = userDefaults.object(forKey: "user") as! Data
                
                do {
                    // test using userDefault var while have not api yet
                    let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedUser) as! Team
                    
                    if name == user.username && pass == user.password {
                        self.navigationController?.pushViewController(bookshelf, animated: true)
                    } else {
                        print("show error")
                        self.errorLabel.isHidden = false
                    }
                } catch {
                    print("Couldn't get user")
                }
            }) { (Error) in
                print("a du")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        self.hideKeyboardWhenTappedAround()
        self.username.delegate = self
        self.password.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let user = UserDefaults.standard.object(forKey: "user") ?? User()
        self.errorLabel.isHidden = true
//        print((user as User).username)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func setupLoginView() {
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
    }
}
