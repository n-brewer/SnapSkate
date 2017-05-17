//
//  FriendProfileVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class FriendProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var profileImageCircle: UIImageView!
    
    var friendsName: String!
    var friendImageUrl: String!
    var rowPicked: Int!
    var friendId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageCircle.layer.cornerRadius = 50
        profileImageCircle.layer.masksToBounds = true
        profileImageCircle.layer.borderColor = UIColor.yellow.cgColor
        profileImageCircle.layer.borderWidth = 2.0
        profileImageCircle.loadImageFromCache(urlString: friendImageUrl)
        
        profileImage.layer.masksToBounds = true
        profileImage.loadImageFromCache(urlString: friendImageUrl)
        userName.text = friendsName
        setupProfile()

    }
    
    @IBAction func viewMapPinsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "friendsMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsMap" {
            let vc = segue.destination as! FriendMap
            vc.friendsId = friendId
        }
        
    }
    func setupProfile() {
        let friendData = DataServices.ds.friendInfo[rowPicked]
        let id = friendData.postedBy
        friendId = id
        let pins = friendData.pinCount
        numberOfPosts.text = pins
        
        
    }

}
