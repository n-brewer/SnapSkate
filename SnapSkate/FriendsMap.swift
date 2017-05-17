//
//  FriendsMap.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/15/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FriendMap: MapVC {
    
    var friendsId: String!
    
    override func viewDidLoad() {
        
        print("KKL\(friendsId)")
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        self.manageUserLocation()
        
        grabFriendsPins(friend: friendsId) { 
            self.mapView.addAnnotations(self.skateSpotList)
        }
        
    }
    
    func grabFriendsPins(friend: String, complete: @escaping downloadComplete) {
        let ref = BASE_URL.child("skateSpots")
        ref.queryOrdered(byChild: "postedBy").queryEqual(toValue: friend).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.skateSpotList = []
                let spots = snapshot.children
                
                for spot in spots {
                    let data = spot as! FIRDataSnapshot
                    
                    let value = data.value as! Dictionary<String, AnyObject>
                    let uniqueId = data.key
                    let newSpot = SkateSpot(value: value, uniqueId: uniqueId)
                    self.skateSpotList.append(newSpot)
                    //                    let newSpot = SkateSpot(skateData: value)
                    print("LLL \(uniqueId)")
                    
                    //                    self.skateSpots.append(newSpot)
                }
            }
            complete()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
