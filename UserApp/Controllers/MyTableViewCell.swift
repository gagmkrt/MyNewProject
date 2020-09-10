//
//  MyTableViewCell.swift
//  UserApp
//
//  Created by Gag Mkrtchyan on 9/10/20.
//  Copyright © 2020 Gag Mkrtchyan. All rights reserved.
//

import UIKit
import AVKit
class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getThumbnailFromImage(url: URL, completion: @escaping ((_ image: UIImage?) -> Void )) {
          DispatchQueue.global().async {
              let asset = AVAsset(url: url)
              let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
              avAssetImageGenerator.appliesPreferredTrackTransform = true
              
              let thumbilTime = CMTimeMake(value: 7, timescale: 1)
              
              do {
                  let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumbilTime, actualTime: nil)
                  let thumbImage = UIImage(cgImage: cgThumbImage)
                  
                  DispatchQueue.main.async {
                      completion(thumbImage)
                  }
                  
              }catch {
                  print(error.localizedDescription)
              }
          }
      }

}
