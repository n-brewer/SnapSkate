//
//  PostVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 4/5/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var addMediaBtn: UIButton!
    @IBOutlet weak var descriptionField: UITextView!
    
    var imageToPost: UIImage?
    var username: String!
    var userImgUrl: String!
    var likes: Int = 0
    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        grabUserInfoForPost()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postTapped(_ sender: UIButton) {
        storePostToFirebase(image: imageToPost!)
        performSegue(withIdentifier: "goToFeed", sender: self)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMediaTapped(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        addMediaBtn.setTitle("", for: .normal)
        addMediaBtn.backgroundColor = UIColor.clear
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        addMediaBtn.setImage(pickedImage, for: .normal)
        self.imageToPost = pickedImage
        
//        storeImageToFirebase(image: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func storePostToFirebase(image: UIImage) {
        
        let uuid = NSUUID().uuidString
        var data = Data()
        var date = NSDate().timeIntervalSince1970
        data = UIImageJPEGRepresentation(image, 0.8)!
        let filePath = STORAGE_URL.child("users").child(USER_ID!).child("postImages").child(uuid)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        filePath.put(data, metadata: metaData) { (metadata, error) in
            if let error = error {
                print("ERRR \(error.localizedDescription)")
                return
            } else {
                let downloadUrl = metadata!.downloadURL()!.absoluteString
                let description = self.descriptionField.text
                let currentDate = self.dateFormatter(timeInterval: date)
                
                let postData: Dictionary<String, String> = [
                    "postImageUrl" : downloadUrl,
                    "postDescription" : description!,
                    "postDate" : "\(currentDate)",
                    "postedBy" : self.username,
                    "userImageUrl" : self.userImgUrl,
                    "likes" : "\(self.likes)"
                ]
                
                BASE_URL.child("Posts").child(USER_ID!).childByAutoId().setValue(postData)
            }
        }
    }
    
    func grabUserInfoForPost() {
        let ref = DataServices.ds.PROFILE_REF
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let info = snapshot.value as! Dictionary<String, String>
            
            let name = info["Username"]
            let imgUrl = info["profileImage"]
            print(name)
            print(imgUrl)
            self.username = name
            self.userImgUrl = imgUrl
            
        })
    }
    
    func dateFormatter(timeInterval: TimeInterval) -> String {
        let currentDate = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd, MMMM yyyy"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: currentDate as Date)
        //        self."\(stat)".text = ("\(dateString)")
        return dateString
    }

}
