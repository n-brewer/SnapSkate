//
//  buttonMagic.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/11/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit

class buttonMagic: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    
    var bankAccount: Int = 1000
    var dronePrice: Int = 900
    var doll: Int = 5000
    

    override func viewDidLoad() {
        super.viewDidLoad()

        myLabel.text = "\(bankAccount)"
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        if myTextField.text != "" {
//            myLabel.text = myTextField.text
            self.view.backgroundColor = UIColor.brown
            attemptPurchase(itemPrice: dronePrice)
        } else {
            print("textfield is empty")
        }
    }
    
    func attemptPurchase(itemPrice: Int) {
        
            self.bankAccount -= itemPrice
            self.myLabel.text = "\(bankAccount)"
            print("got it.....\(self.bankAccount)")
    }
}









