//
//  AuthViewController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 8/21/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AuthViewController: UIViewController {
    
        var singUp = true {
        willSet {
            if newValue {
                chekIn.text = "Register"
                nameField.isHidden = false
                signUp.setTitle("Sing In", for: .normal)
                emailField.text = nil
                passwordField.text = nil
                forgetPassword.isHidden = true

            } else {
                chekIn.text = "Sing In"
                nameField.isHidden = true
                signUp.setTitle("Register", for: .normal)
                emailField.text = nil
                passwordField.text = nil
                forgetPassword.isHidden = false

            }
        }
    }
    
    @IBOutlet weak var chekIn: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        forgetPassword.isHidden = true
        
        let buttonFb = FBLoginButton()
        buttonFb.center = view.center
        buttonFb.frame.origin.y = 465
        view.addSubview(buttonFb)
        buttonFb.delegate = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !CheckInternet.Connection() {
            
            self.alertForAll(title: "Oops!", message: "Your Device is not connected with internet")
        }
    }
    
    
   func alertForAll(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func tapForHideKeyboard(_ sender: UITapGestureRecognizer) {
        
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
   
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        singUp = !singUp
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        
        present(vc, animated: true, completion: nil)
    }
    
    
}


extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
            let name = nameField.text!
            let email = emailField.text!
            let password = passwordField.text!
        
        if CheckInternet.Connection() {
            
            if singUp {
                if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error == nil {
                            
                            if let result = result {
                                print(result.user.uid)
                                
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                                UIApplication.shared.windows.first?.rootViewController = vc
                            }
                        } else if self.emailField.text != result?.user.email {
                            self.alertForAll(title: "Error", message: "No such email address exists")
                        }
                    }
                    
                } else {
                    alertForAll(title: "Warning", message: "Please fill the all fields")
                }
                
            } else {
                if !email.isEmpty && !password.isEmpty {
                    
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil {
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                            UIApplication.shared.windows.first?.rootViewController = vc
                            
                        } else if self.emailField.text != result?.user.email {
                            self.emailField.resignFirstResponder()
                            self.passwordField.resignFirstResponder()
                            self.alertForAll(title: "Error", message: "Wrong email address or password")
                            self.emailField.text = nil
                            self.passwordField.text = nil
                        }
                    }
                    
                } else {
                    
                    alertForAll(title: "Warning", message: "Please fill the all fields")
                }
            }
            
        } else {
            self.alertForAll(title: "Oops!", message: "Your Device is not connected with internet")
            
        }
        
        return true
    }
}

extension AuthViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result!.isCancelled {
            print("cancelled")
            
        } else {
            if error == nil {
                GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start { (nil, result, error) in
                    if error == nil {
                        print(result)
                        
                        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                        
                        Auth.auth().signIn(with: credential) { (result, error) in
                            if error == nil {
                                print(result?.user.uid)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
                                
                                UIApplication.shared.windows.first?.rootViewController? = vc
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
    }
    
    
}
