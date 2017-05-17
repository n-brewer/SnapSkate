//
//  DataServices.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/11/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

let BASE_URL = FIRDatabase.database().reference()
let USER_ID = FIRAuth.auth()?.currentUser?.uid

let STORAGE_URL = FIRStorage.storage().reference()
var numberOfUploads: Int!

typealias downloadComplete = () -> ()


class DataServices {
    static let ds = DataServices()
    
    let PROFILE_REF = BASE_URL.child("Users").child(USER_ID!)
    
    var feedInfo = [FirebaseData]()
    var friendInfo = [FirebaseData]()
    
    var loggedInUsername: String!
    var userPinCount: Int!
    var userFollowingCount: Int!
    var userImageUrl: String!
    
    func grabUploadCount() {
        let countRef = BASE_URL.child("uploadCount")
        countRef.observe(.value, with: { (snapshot) in
            let data = snapshot.value as! Dictionary<String, Int>
            let count = data["count"]
            print("DDDDD \(count!)")
            numberOfUploads = count!
        })
    }
    
    func findFriends() {
        
        let ref = BASE_URL.child("Following").child(USER_ID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.friendInfo = []
            let data = snapshot.value as! Dictionary<String, AnyObject>
            for key in data {
                let name = key.key
                
                let newRef = BASE_URL.child("Users").child(name)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let newData = snapshot.value as! Dictionary<String, String>
                    let results = FirebaseData(friendListData: newData, friendId: name)
//                    print(results.friendImageUrl)
                    self.friendInfo.append(results)
                    print(results.friendName)
                    
                    //                    print("DUDE\(friendName!)")
                    //                    self.friendImageUrls.append(imageUrl!)
                    //                    self.friendNames.append(friendName!)
                    //                    print("BOB \(self.friendNames.count)")
                })
            }
            }
        })
        
    }

    
}
