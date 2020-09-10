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

class MenuViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            
            UIApplication.shared.windows.first?.rootViewController = vc
            
        } catch {
            print(error)
        }
    }
    
//    @IBAction func changeColorButton(_ sender: UIButton) {
//
//        delegate?.changeColor()
//        dismiss(animated: true, completion: nil)
//        
//    }
    
    
}
    
  


