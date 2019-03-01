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
//                let alert = UIAlertController(title: "", message: "You have successfully borrowed books", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                self.errorLabel.isHidden = false
            }
            
            
//            Api.shared.login(username: name, password: pass, success: { (deptrai) in
//                // deptrai is variable store user information
//                let stboard = UIStoryboard.init(name: "Main", bundle: nil)
//                let bookshelf = stboard.instantiateViewController(withIdentifier: "bookshelfVC") as! BookshelfViewController
//
//                if name.isEmpty || pass.isEmpty {
//                    self.errorLabel.isHidden = false
//                    return
//                }
//
//                self.errorLabel.isHidden = true
//                let userDefaults = UserDefaults.standard
//
//                if let decodedUser = userDefaults.object(forKey: "user") as? Data {
//                    do {
//                        // test using userDefault var while have not api yet
//                        let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedUser) as! User
//
//                        if name == user.username && pass == user.password {
//                            self.navigationController?.pushViewController(bookshelf, animated: true)
//                        } else {
//                            print("show error")
//                            self.errorLabel.isHidden = false
//                        }
//                    } catch {
//                        print("Couldn't get user")
//                    }
//                } else {
//                    self.errorLabel.isHidden = false
//                }
//
//            }) { (Error) in
//                print("a du")
//            }
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
    }
}
