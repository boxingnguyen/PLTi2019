//
//  ResetPassViewController.swift
//  PLTi2019
//
//  Created by Quyen Anh on 3/4/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var PIN: UITextField!
    @IBOutlet weak var errConfirmPass: UILabel!
    @IBOutlet weak var errPIN: UILabel!
    
    var lostAccountEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupView()
    }
    
    func setupView() {
        // setUp back button and transparent bar
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.turnBack(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.newPass.delegate = self
        self.confirmPass.delegate = self
        self.PIN.delegate = self
        designTextfield(textField: newPass, placeHolder: "New password")
        designTextfield(textField: confirmPass, placeHolder: "Confirm password")
        designTextfield(textField: PIN, placeHolder: "6 digit PIN")
        
        self.view.backgroundColor = GREEN_THEME
        errConfirmPass.isHidden = true
        errPIN.isHidden = true
    }
    
    func designTextfield(textField: UITextField, placeHolder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.setBottomBorder(backGroundColor: GREEN_THEME, borderColor: UIColor.white)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    @objc func turnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func resetPass(_ sender: Any) {
        let newPass = self.newPass.text
        let confirmPass = self.confirmPass.text
        let pin = self.PIN.text
        
        if newPass!.isEmpty || confirmPass!.isEmpty || pin!.isEmpty {
            errPIN.text = "All fields are required!"
            errPIN.isHidden = false
            errConfirmPass.isHidden = true
            return
        }
        
        if confirmPass != newPass {
            errConfirmPass.text = "Confirm password's not match!"
            errConfirmPass.isHidden = false
            errPIN.isHidden = true
            return
        }
        
        if lostAccountEmail.isEmpty {
            return
        }
        
        // send api to server, check pin and reset password
        ApiService.shared.resetPass(email: self.lostAccountEmail, newPass: newPass!, pin: pin!, success: { (result) in
            if result == self.lostAccountEmail {
                self.errPIN.isHidden = true
                
                // alert change password successful
                let alert = UIAlertController(title: "Success", message: "You reseted password successfully!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    // back to login
                    let stboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let loginVC = stboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                    loginVC.resetPass = true
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }) { (Error) in
            if Error._code == 104 {
                self.errPIN.text = "PIN is not correct!"
                self.errPIN.isHidden = false
                self.errConfirmPass.isHidden = true
            }
            print(Error)
        }
    }
    
}
