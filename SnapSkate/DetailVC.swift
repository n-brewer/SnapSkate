//
//  DetailVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/9/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class DetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ssTitle: UILabel!
    @IBOutlet weak var ssLocation: UILabel!
    @IBOutlet weak var postedByUser: UILabel!
    @IBOutlet weak var skateSpotImage: UIImageView!
    @IBOutlet weak var addPicBtn: UIButton!
    
    var annotationDetails: SkateSpot?
    let picker = UIImagePickerController()
    var dataToTransfer: String!
    var picScene = ImagesCVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(annotationDetails?.uniqueId)")
        picker.delegate = self
        
        grabFirebaseData()

        print("SS \(annotationDetails?.uniqueId)")
        ssLocation.text = annotationDetails?.locationName
        ssTitle.text = annotationDetails?.skateSpotTitle
        postedByUser.text = annotationDetails?.postedByUser
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        skateSpotImage.image = imagePicked
        
        storeImageToFirebase(image: imagePicked)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPicBtnTapped(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        addPicBtn.setTitle("", for: .normal)
        addPicBtn.backgroundColor = .clear
        present(picker, animated: true, completion: nil)

    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backToMap", sender: self)
    }
    
    @IBAction func seePicsTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPics" {
            print("SEGUE WORKED")
            let destVC: ImagesCVC = segue.destination as! ImagesCVC
            destVC.chosenSpot = (annotationDetails?.uniqueId)!
        }
    }
    
    func grabFirebaseData() {
        let ref = BASE_URL.child("skateSpotImages")
        
        ref.observe(.value, with: { (snapshot) in
            if snapshot.hasChild((self.annotationDetails?.uniqueId)!) {
                
                let storageRef = STORAGE_URL.child("skateSpotImages").child((self.annotationDetails?.uniqueId)!)
                storageRef.downloadURL(completion: { (url, error) in
                    if let er = error {
                        print(er.localizedDescription)
                    } else {
                        let imageUrl = url
                        print("\(imageUrl)")
                        self.skateSpotImage.sd_setImage(with: imageUrl)
                    }
                })
            }
        })
    }
    
    func storeImageToFirebase(image: UIImage) {
        var data = Data()
        data = UIImageJPEGRepresentation(image, 0.8)!
        let filePath = STORAGE_URL.child("skateSpotImages").child((self.annotationDetails?.uniqueId)!).child("\(numberOfUploads!)")
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"

        filePath.put(data, metadata: metaData) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.addToUploadCount()
                let downloadUrl = metadata!.downloadURL()!.absoluteString
                let imageDict: Dictionary<String, String> = ["imageUrl": downloadUrl]
                BASE_URL.child("skateSpotImages").child((self.annotationDetails?.uniqueId)!).childByAutoId().setValue(imageDict)
            }
        }
    }
    
    func addToUploadCount() {
        let ref = BASE_URL.child("uploadCount")
        let newCount = (numberOfUploads! + 1)
        let update = ["count" : newCount]
        ref.updateChildValues(update)
    }

}
