//
//  LoginVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/11/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                self.present(vc, animated: true, completion: nil)
            }
        })

        enterBtn.layer.cornerRadius = 8.0
        
    }
    
    
    func addOrCreateUser() {

        if let email: String = emailField.text, let pwd: String = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "goToProfile", sender: self)
                    print("signed in with email")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("Unable to create new user")
                        } else {
                            print("Successfully created user")
                            self.performSegue(withIdentifier: "goToNewProfile", sender: self)
                        }
                    })
                }
            })
        }
    }

    
    
    @IBAction func enterHereTapped(_ sender: UIButton) {
        addOrCreateUser()
        
    }
    
}
