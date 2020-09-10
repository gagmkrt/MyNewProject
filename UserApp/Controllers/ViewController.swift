//
//  ViewController.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 8/21/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import AVKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menu : SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
//        menu = SideMenuNavigationController(rootViewController: MenuListController())
//        menu?.leftSide = true
//        SideMenuManager.default.leftMenuNavigationController = menu
//        menu?.view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        tableView.rowHeight = view.bounds.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    var player = AVPlayer()
       var avPlayerController = AVPlayerViewController()
       
               
       let urlArray = ["https://media.e11evate.co.uk/api/Image/Download/CroppedPostFile/video-637148817616325109_cropped.mp4", "https://media.e11evate.co.uk/api/Image/Download/CroppedPostFile/video-637148817214585222_cropped.mp4", "https://media.e11evate.co.uk/api/Image/Download/CroppedPostFile/video-637148816379670003_cropped.mp4", "https://media.e11evate.co.uk/api/Image/Download/CroppedPostFile/video-637148815250094987_cropped.mp4"]
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !CheckInternet.Connection() {
            alert()
        }
        
    }
    
    
    
    func alert() {
        
        let alert = UIAlertController(title: "Oops!", message: "Your Device is not connected with internet", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
    
    @IBAction func swipeForMenu(_ sender: UISwipeGestureRecognizer) {
        let vc = storyboard!.instantiateViewController(identifier: "SideMenuNavigationController") as! SideMenuNavigationController
        present(vc, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        let vc = storyboard!.instantiateViewController(identifier: "SideMenuNavigationController") as! SideMenuNavigationController
        present(vc, animated: true, completion: nil)

    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        let stringURL = URL(string: urlArray[indexPath.row])
        cell.getThumbnailFromImage(url: stringURL! ) { (image) in
            cell.videoImage.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(indexPath: indexPath)
    }
    
    func playVideo(indexPath: IndexPath) {
        
        let url = URL(string: urlArray[indexPath.row])
        player = AVPlayer(url: url!)
        avPlayerController.player = player
        
        present(avPlayerController, animated: true) {
            self.player.play()
        }
    }
    
    
}

