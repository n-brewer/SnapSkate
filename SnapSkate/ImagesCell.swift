//
//  ImagesCell.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/25/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class ImagesCell: UICollectionViewCell  {
    
    @IBOutlet weak var skateImage: UIImageView!
    
    override func layoutIfNeeded() {
        
    }
    
    func configureCell(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            if let imageData = NSData(contentsOf: url) {
                let img = UIImage(data: imageData as Data)
                
                skateImage.image = img
            }
        }
    }
    
    func designCell(img: UIImage) {
        skateImage.image = img
    }
    
}
