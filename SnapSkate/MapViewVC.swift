//
//  MapViewVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/8/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import MapKit

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? SkateSpot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.frame.size = CGSize(width: 200, height: 200)
                
//                view.image?.accessibilityFrame.size = CGSize(width: 50, height: 50)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.image = UIImage(named: "handrail")
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? SkateSpot
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print(selectedAnnotation!.skateSpotTitle)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.annotationDetails = selectedAnnotation
//        vc.ssTitle.text = selectedAnnotation?.skateSpotTitle
//        vc.ssLocation.text = selectedAnnotation!.locationName
//        vc.view.frame.size.width = self.view.frame.size.width / 2
//        vc.view.frame.size.height = self.view.frame.size.height / 2
//
//        mapView.isHidden = true
        self.present(vc, animated: true, completion: nil)
        
//        let detailView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//        detailView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
//        detailView.backgroundColor = .cyan
//        mapView.addSubview(detailView)
//        let location = view.annotation as? SkateSpot
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        location?.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
