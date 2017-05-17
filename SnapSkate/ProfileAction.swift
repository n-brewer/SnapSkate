//
//  ProfileAction.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/15/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class ProfileAction: UIImageView {
    
    var identifier: String {
        return "ProfileVC"
    }

    override func awakeFromNib() {
        let tap = CustomGesture(target: self, action: #selector(newVC), id: identifier)
        self.addGestureRecognizer(tap)
        print("Tap")
    }
    
    func newVC(_ sender: CustomGesture) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: sender.id)
        let currentVC = self.getCurrentViewController()
        currentVC?.present(vc, animated: true, completion: nil)
        print("TURD \(sender.id)")
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
}

class CustomGesture: UITapGestureRecognizer {
    
    var id: String!
    
    init(target: Any?, action: Selector?, id: String) {
        super.init(target: target, action: action)
        
        self.id = id
    }
}




