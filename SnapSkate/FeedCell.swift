//
//  FeedCell.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 4/9/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var postDescLbl: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: FirebaseData) {
        usernameLbl.text = data.postedBy
        dateLbl.text = data.postDate
        postDescLbl.text = data.postDesc
        likesLbl.text = data.likes
        
//        if let url = URL(string: data.userImageUrl) {
//            let imageData = NSData(contentsOf: url)
//            let pic = UIImage(data: imageData as! Data)
//            
//            self.posterImage.image = pic
//        }
//        
//        if let mediaUrl = URL(string: data.mediaUrl) {
//            let mediaData = NSData(contentsOf: mediaUrl)
//            let mediaPic = UIImage(data: mediaData as! Data)
        
//            self.postImage.image = mediaPic
//        }
        
    }

}
