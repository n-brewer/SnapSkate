//
//  SkateSpot.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/8/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class SkateSpot: NSObject, MKAnnotation {
    
    var skateSpotTitle: String = ""
    var locationName: String = ""
    var discipline: String = ""
    var imageUrl: String = ""
    var lat: CLLocationDegrees = 0.0
    var long: CLLocationDegrees = 0.0
    var postedByUser: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var uniqueId: String = ""
    
    init(value: Dictionary<String, AnyObject>, uniqueId: String) {
        self.uniqueId = uniqueId
        
        let lat = value["latitude"] as! CLLocationDegrees
        let long = value["longitude"] as! CLLocationDegrees
        let title = value["title"] as! String
        let type = value["skateType"] as! String
        let postedBy = value["postedBy"] as! String
        let location = value["location"] as! String
        let imageUrl = value["imageUrl"] as! String
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.skateSpotTitle = title
        self.discipline = type
        self.imageUrl = imageUrl
        self.postedByUser = postedBy
        self.locationName = location

    }
    
    init(imgUrlDict: Dictionary<String, String>) {
        let imgUrl = imgUrlDict["imageUrl"]
        self.imageUrl = imgUrl!
    }
    
//    init(title: String, locationName: String, discipline: String, imageUrl: String, lat: CLLocationDegrees, long: CLLocationDegrees, postedBy: String) {
//        self.skateSpotTitle = title
//        self.locationName = locationName
//        self.discipline = discipline
//        self.imageUrl = imageUrl
////        self.lat = lat
////        self.long = long
//        self.postedByUser = postedBy
//        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        super.init()
//
//
//    }

//    convenience init(title: String, locationName: String, discipline: String, imageUrl: String, lat: CLLocationDegrees, long: CLLocationDegrees, postedBy: String) {
//        
//        self.init(title: title, locationName: locationName, discipline: discipline, imageUrl: imageUrl, lat: lat, long: long, postedBy: postedBy, coords: 2020)
//        
//            self.postedByUser = postedBy
//            self.discipline = discipline
//            self.skateSpotTitle = title
//            self.locationName = locationName
//            self.lat = lat
//            self.long = long
//            self.imageUrl = imageUrl
//
//    }
//    convenience init(skateData: Dictionary<String, AnyObject>) {
//        self.init(skateData: skateData)
//        
//        if let postedBy = skateData["postedBy"] as? String {
//            self.postedByUser = postedBy
//        }
//        
//        if let skateType = skateData["skateType"] as? String {
//            self.discipline = skateType
//        }
//        
//        if let skateTitle = skateData["title"] as? String {
//            self.skateSpotTitle = skateTitle
//        } 
//        
//        if let location = skateData["location"] as? String ?? nil {
//            self.locationName = location
//        }
//        
//        if let lat = skateData["latitude"] as? CLLocationDegrees {
//            self.lat = lat
//        }
//        
//        if let long = skateData["longitude"] as? CLLocationDegrees {
//            self.long = long
//        }
//        
//        if let imgUrl = skateData["imageUrl"] as? String {
//            self.imageUrl = imgUrl
//        }
//        
//    }
    
    var subtitle: String? {
        return locationName
    }
    
    var title: String? {
        return skateSpotTitle
    }
    
    func mapItem() -> MKMapItem {
        
        let addressDict = [String(kABPersonAddressStreetKey): subtitle]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        
        return mapItem
    }
}
