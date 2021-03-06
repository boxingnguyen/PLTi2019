//
//  SignUpViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/28/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var invalidEmail: UILabel!
    @IBOutlet weak var blankFieldErr: UILabel!
    
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
        setupHaveAccountButton()
        setupView()
        self.hideKeyboardWhenTappedAround()
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
    }
    
    func setupView() {
        view.backgroundColor = GREEN_THEME
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
        invalidEmail.isHidden = true
        blankFieldErr.isHidden = true
        
        // setUp back button and transparent bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        self.dismissKeyboard()
        return true
    }
    
    @objc func signInAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        // validate username, email, password
        if let username = self.username.text, let email = self.email.text, let password = self.password.text {
            if username.isEmpty || email.isEmpty || password.isEmpty {
                blankFieldErr.isHidden = false
                blankFieldErr.textColor = UIColor.red
                blankFieldErr.text = "All fields are required!"
                invalidEmail.isHidden = true
                return
            }
            
            blankFieldErr.isHidden = true
            
            if !isValidEmail(testStr: email) {
                invalidEmail.isHidden = false
                invalidEmail.text = "Your email address is invalid, please check!"
                invalidEmail.textColor = UIColor.red
                return
            }
            
            print(username, " ", email, " ", password)
            invalidEmail.isHidden = true
            
            // send api to save new account
            ApiService.shared.apiRegister(user: username, email: email, pass: password, success: { (userJson) in
                print("User \(userJson)")
                
                let alert = UIAlertController(title: "Success", message: "You have signed up successfully!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //come back login
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                // after save in dbs ok -> save in session
                do {
                    let user = User(id: userJson.id , username: userJson.username, email: userJson.email, password: userJson.password)
                    let encodedData = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                    
                    UserDefaults.standard.set(encodedData, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                } catch {
                    print("Couldn't save user")
                }
                
            }) { (err) in
                print("Error \(err.localizedDescription)")
            }
            
            
//            // after save in dbs ok -> save in session
//            do {
//                let user = User(username: username, email: email, password: password)
//                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
//
//                UserDefaults.standard.set(encodedData, forKey: "user")
//                UserDefaults.standard.synchronize()
//            } catch {
//                print("Couldn't save user")
//            }
//
//            // return to login (bookshefl) page
//            print("signup successfull")
//            let stboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let loginVC = stboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//
//            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    fileprivate func setupHaveAccountButton() {
        view.addSubview(haveAccountButton)
        
        haveAccountButton.anchors(top: nil, topPad: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  bottomPad: 30, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor,
                                  rightPad: 0, height: 33, width: 0)
    }
}
