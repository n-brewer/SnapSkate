//
//  ViewController.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/7/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var addSkateSpotBtn: UIButton!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var currentLocationCoords: CLLocation!
    var skateSpotList = [SkateSpot]()
    var selectedAnnotation: SkateSpot?
//    var testSpot: SkateSpot!
    
//    let eachSpot = SkateSpotList().spot

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GGGGGG\(numberOfUploads)")
//        print("TEST\(skateSpotList)")

        grabSkateSpots {
            self.mapView.addAnnotations(self.skateSpotList)
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        manageUserLocation()
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
//        mapView.addAnnotation(eachSpot)
        
//        let skateSpot = SkateSpot(title: "7 Stair", locationName: "Cottonwood HS", discipline: "Stairs", imageUrl: "", coordinate: CLLocationCoordinate2D(latitude: 40.5, longitude: -111))
//        
//        mapView.addAnnotation(skateSpot)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        currentLocationCoords = CLLocation(latitude: lat, longitude: long)
        
        centerMapOnLocation(location: currentLocationCoords)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("RIGHT HERE \(error.localizedDescription)")
    }
    
    func manageUserLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordRegion, animated: true)
    }
    
    @IBAction func addSkateSpotTapped(_sender: UIButton) {
        
        let alert = UIAlertController(title: "Add Skate Spot", message: "Please fill in accurately", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action) in
            let newTitle = alert.textFields?[0].text
            let newSpot = alert.textFields?[1].text
            
            let ref = BASE_URL.child("skateSpots").childByAutoId()
            let skateData: Dictionary<String, AnyObject> = [
                "skateType" : "Stairs" as AnyObject,
                "postedBy" : USER_ID! as AnyObject,
                "title" : newTitle! as AnyObject,
                "location" : newSpot! as AnyObject,
                "latitude" : self.currentLocationCoords.coordinate.latitude as AnyObject,
                "longitude" : self.currentLocationCoords.coordinate.longitude as AnyObject,
                "imageUrl" : "SomeURL" as AnyObject,
//                "coordinates" : self.currentLocationCoords! as AnyObject
            ]
            
            ref.setValue(skateData)
            
//            let newSkateSpot = SkateSpot(title: newTitle!, locationName: newSpot!, discipline: "stair", imageUrl: "", coordinate: self.currentLocationCoords.coordinate)
//            print(self.currentLocationCoords.coordinate)
//            self.mapView.addAnnotation(newSkateSpot)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Type of Spot, ex: handrail, 8-stair.."
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Location, ex: Walmart, Los Angeles"
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
        
//        let newSkateSpot = SkateSpot(title: "new thing", locationName: "the mountains", discipline: "slope", imageUrl: "", coordinate: CLLocationCoordinate2D(latitude: 40.499, longitude: -111.012))
//        
        
    }
    
    func grabSkateSpots(complete: @escaping downloadComplete) {
        let ref = BASE_URL.child("skateSpots")
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                
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

