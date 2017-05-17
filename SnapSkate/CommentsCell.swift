//
//  CommentsCell.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/9/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    @IBOutlet weak var commentField: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configureCommentCell(data: FirebaseData) {
        commentField.text = data.message
        dateLbl.text = data.commentDate
        posterImage.loadImageFromCache(urlString: data.commentImgUrl)
    }

}
