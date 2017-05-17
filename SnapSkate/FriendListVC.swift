//
//  FriendListVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/12/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class FriendListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
//    var friendsArray = [FirebaseData]()
//    
//    var friendImageUrls = [String]()
//    var friendNames: [String] = []
    var friendsName: String!
    var friendsUrl: String!
    var pickedRow: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        DataServices.ds.findFriends()

//        findFriends {
            print("ZZZ \(DataServices.ds.friendInfo.count)")
//        }
//        
        DispatchQueue.main.async {
            self.tableview.reloadData()
            print("CVB \(DataServices.ds.friendInfo.count)")
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataServices.ds.friendInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
            
        let friendData = DataServices.ds.friendInfo[indexPath.row]
        cell.configureFriendCell(data: friendData)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // transition to selected users profile
        pickedRow = indexPath.row
        
        let data = DataServices.ds.friendInfo[pickedRow]
        friendsName = data.friendName
        friendsUrl = data.friendImageUrl
        print(friendsName)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let friendVC = storyboard.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
        friendVC.friendsName = friendsName ?? ""
        friendVC.friendImageUrl = friendsUrl
        friendVC.rowPicked = pickedRow

        present(friendVC, animated: true, completion: nil)
        
    }

}
