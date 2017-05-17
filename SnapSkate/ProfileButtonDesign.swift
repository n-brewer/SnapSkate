//
//  ProfileButtonDesign.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/14/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class ProfileButtonDesign: UIButton {

    override func awakeFromNib() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.8
        layer.cornerRadius = 3.0
//        layer.masksToBounds = true
    }

}
