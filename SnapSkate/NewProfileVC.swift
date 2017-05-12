//
//  NewProfileVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/12/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class NewProfileVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var hobbyTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        if usernameTF.text != "" && hobbyTF.text != "" {
            let ref = BASE_URL.child("Users").child(USER_ID!)
            let profileDict: Dictionary<String, String> = ["Username" : (usernameTF.text?.capitalized)!, "Hobby" : (hobbyTF.text?.capitalized)!]
            ref.setValue(profileDict)
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        FIRAuth.auth()?.currentUser?.delete(completion: nil)
        
    }

}
