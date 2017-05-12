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
    
    func grabUploadCount() {
        let countRef = BASE_URL.child("uploadCount")
        countRef.observe(.value, with: { (snapshot) in
            let data = snapshot.value as! Dictionary<String, Int>
            let count = data["count"]
            print("DDDDD \(count!)")
            numberOfUploads = count!
        })
    }
    
}
