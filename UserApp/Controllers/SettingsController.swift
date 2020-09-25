//
//  SettingsController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 9/11/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Firebase

class SettingsController: UIViewController {
    
    @IBOutlet weak var imagesView: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let user = Auth.auth().currentUser
    
   static var userName : String?
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    
    var urlString = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        imagesView.layer.borderWidth = 3
        imagesView.layer.borderColor = UIColor.lightGray.cgColor
        
        setInfoFacbook()
        setInfoAuth()
    
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(taping))
        imagesView.addGestureRecognizer(tap)
        imagesView.isUserInteractionEnabled = true
        
//        if let imgData = UserDefaults.standard.object(forKey: "myImageKey") as? NSData {
//            imagesView.image = UIImage(data: imgData as Data)
//        }
        
    }
    
    
    @objc func taping() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let actionPhoto = UIAlertAction(title: "Photo Gallery", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func setInfoAuth() {
        if user != nil {
            labelText.text = user?.email
//            let urlString = user?.photoURL?.absoluteURL
//
//            guard let url = urlString else { return }
//
//            imagesView.load(url: url)
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
                            let pictureURL = URL(string: profilePic)
                            self.imagesView.load(url: pictureURL!)
                            
                        }
                    }
                }
            }
        }
    }
    
    
//    func downloadImage() {
//        let ref = Storage.storage().reference(forURL: urlString)
//        let megaByte = Int64(1 * 1024 * 1024)
//
//        ref.getData(maxSize: megaByte) { (data, error) in
//            guard data != nil else { return }
//
//            self.imagesView.image = UIImage(data: data!)
//        }
//
//    }
    
    
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storagRef = Storage.storage().reference().child("user/\(uid)")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        storagRef.putData(imageData, metadata: metaData) { metaData, error in

            guard metaData != nil else {
                completion(.failure(error!))

                return
            }

            storagRef.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))

                    return
                }
                completion(.success(url))
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


extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicker = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagesView.image = imagePicker
            
        }
        
//        let data = imagesView.image?.pngData()
//        defaults.set(data, forKey: "myImageKey")
//        UserDefaults.standard.synchronize()
//
        dismiss(animated: true, completion: nil)
        
        if self.imagesView.image != nil {
            guard let image = self.imagesView.image else { return }
            
            self.uploadProfileImage(image) { (result) in
                switch result {
                
                case .success(let url):
                    print(url)
                    self.urlString = url.absoluteString

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}



