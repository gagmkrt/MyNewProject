//
//  MenuViewController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 8/23/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import FirebaseAuth
import FBSDKLoginKit

class MenuViewController: UIViewController {
    
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            
            UIApplication.shared.windows.first?.rootViewController = vc
            
        } catch {
            print(error)
        }
        
        loginManager.logOut()
        
    }
    
    
}
    
  


