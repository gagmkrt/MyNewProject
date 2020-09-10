//
//  ForgetPasswordViewController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 8/21/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import UIKit
import Firebase

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!

    let notificationCenter = NotificationCenter.default

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
        
   
    
    @IBAction func closeChanging(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func changePassword(_ sender: UIButton) {
        let email = emailField.text!
        
        if CheckInternet.Connection() {
            
            if !email.isEmpty {
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        self.alertForAll(title: "Error", message: "Wrong email address")
                        self.emailField.text = nil
                    }
                }
                
            } else {
                self.alertForAll(title: "Warning", message: "Please fill the field")
            }
            
        } else {
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
        
        emailField.resignFirstResponder()
    }
    
   

}

