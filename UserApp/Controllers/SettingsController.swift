//
//  SettingsController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 9/11/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class SettingsController: UIViewController {
    
    @IBOutlet weak var imagesView: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let user = Auth.auth().currentUser
    
   static var userName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        imagesView.layer.borderWidth = 3
        imagesView.layer.borderColor = UIColor.lightGray.cgColor
        
        setInfoFacbook()
        setInfoAuth()
        
    }
    
    
    func setInfoAuth() {
        if user != nil {
            labelText.text = user?.email
        }

    }
    
    
    
    func setInfoFacbook() {
        GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start { (nil, result, error) in
            if error == nil {
                guard let json = result as? NSDictionary else { return }
                if let firstName = json["name"] as? String {
                    self.labelText.text = firstName
                    
                }
                
                if let profilePicObj = json["picture"] as? [String:Any] {
                    if let profilePicData = profilePicObj["data"] as? [String:Any] {
                        if let profilePic = profilePicData["url"] as? String {
                            print("\(profilePic)")
                            let pictureURL = URL(string: profilePic)
                            self.imagesView.load(url: pictureURL!)
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell", for: indexPath) as! SettingsViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let vc = UIStoryboard(name: "StoryboardForCells", bundle: nil).instantiateViewController(identifier: "DidSelectController") as! DidSelectController
            
            guard let tabBar = tabBarController?.tabBar else { return }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



