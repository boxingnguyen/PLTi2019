//
//  LoginViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/25/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
//import Alamofire

protocol selectBookDelegate {
    func chooseBookReload(_ result: Book)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var forgotView: UIView!
    @IBOutlet weak var forgotEmail: UITextField!
    @IBOutlet weak var forgotErrorMesg: UILabel!
    
    var selectBook = Book(id: "", name: "", author: "", image: "", catergory: .all, isBorrow: false, user_borrow_id: "")
    var delegate: selectBookDelegate?
    
    @IBAction func btnLoginTouch(_ sender: Any) {
        
        if let email = email.text, let pass = password.text {
            // check error input fields
            if email.isEmpty || pass.isEmpty {
                self.errorLabel.isHidden = false
                return
            }
            
            ApiService.shared.apiLogin(email: email, pass: pass, success: { (userJson) in
                // save user
                let user = UserDefaults.standard
                user.set(userJson.email, forKey: "email")
                user.set(userJson.id, forKey: "id")
                user.set(userJson.username, forKey: "user")
                // pop bookshelf

                // add book to chooseBook
                self.delegate?.chooseBookReload(self.selectBook)
                
                self.navigationController?.popViewController(animated: true)
                
            }) { (err) in
                print("Loi \(err.localizedDescription)")
                self.errorLabel.isHidden = false
                return
            }
        }
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        self.hideKeyboardWhenTappedAround()
        self.email.delegate = self
        self.password.delegate = self
        self.forgotEmail.delegate = self
        
        print("Book \(selectBook.name) and \(selectBook.author)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let user = UserDefaults.standard.object(forKey: "user") ?? User()
        self.errorLabel.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func setupLoginView() {
        btnLogin.layer.cornerRadius = 10
        view.backgroundColor = GREEN_THEME
        navigationController?.isNavigationBarHidden = false

        // setUp back button and transparent bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        email.textColor = .white
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
        
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
        
        forgotEmail.attributedPlaceholder = NSAttributedString(string: "Your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        forgotEmail.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
        showForgotView()
    }
    
    func showForgotView() {
        forgotView.frame = self.view.frame
        forgotView.backgroundColor = GREEN_THEME
        forgotErrorMesg.isHidden = true
        self.view.addSubview(forgotView)
        self.navigationController?.navigationBar.isHidden = true
        
    }

    
    @IBAction func forgotBtnCancel(_ sender: Any) {
        self.forgotView.removeFromSuperview()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func forgotSumbit(_ sender: Any) {
        if self.forgotEmail.text!.isEmpty  {
            forgotErrorMesg.text = "Email can't not be blank!"
            forgotErrorMesg.isHidden = false
            return
        }

        if !isValidEmail(testStr: self.forgotEmail.text!) {
            forgotErrorMesg.text = "Your email address is invalid, please check!"
            forgotErrorMesg.isHidden = false
            return
        }
        
        forgotErrorMesg.isHidden = true
        let lostEmail = self.forgotEmail.text!
        print(lostEmail)

        // send api to send email
    }
    

}
