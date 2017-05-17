//
//  FriendListCell.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/12/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class FriendListCell: UITableViewCell {
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        friendImage.layer.cornerRadius = 25
        friendImage.layer.masksToBounds = true
    }
    
    func configureFriendCell(data: FirebaseData) {
        self.friendName.text = data.friendName
        
        self.friendImage.loadImageFromCache(urlString: data.friendImageUrl)
    }

}
