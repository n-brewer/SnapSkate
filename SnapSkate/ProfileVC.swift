//
//  ProfileVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/11/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHobby: UILabel!
    @IBOutlet weak var addPicBtn: UIButton!
    
    @IBOutlet weak var userPinCount: UILabel!
    @IBOutlet weak var userFollowingCount: UILabel!
    
    let picker = UIImagePickerController()
    var userPhoto: UIImage!
    
    var passThis = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GGGGGG\(numberOfUploads)")
        
        grabProfileData {
            addPicBtn.setTitle("", for: .normal)
            addPicBtn.backgroundColor = .clear
        }
        DataServices.ds.findFriends()
//        grabPostInfo {
//            print("DONE")
//        }
        
        
        picker.delegate = self

        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.yellow.cgColor
        profileImage.layer.borderWidth = 2.0
    }
    
    @IBAction func addPicTapped(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        addPicBtn.setTitle("", for: .normal)
        addPicBtn.backgroundColor = .clear
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func goToMapTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func makePostTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "makePost", sender: self)
    }
    
    @IBAction func goToCrew(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFriends", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToCrew" {
//            
//            let destVc: FriendListVC = segue.destination as! FriendListVC
//            
//            let ref = BASE_URL.child("Following").child(USER_ID!)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                let data = snapshot.value as! Dictionary<String, AnyObject>
//                for key in data {
//                    let name = key.key
//                    
//                    let newRef = BASE_URL.child("Users").child(name)
//                    newRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                        let newData = snapshot.value as! Dictionary<String, String>
//                        let imageUrl = newData["profileImage"]
//                        let friendName = newData["Username"]
//                        
//                        print("DUDE\(friendName!)")
//                        destVc.friendImageUrls.append(imageUrl!)
//                        self.passThis.append(friendName!)
//                        print("BOB \(destVc.friendNames.count)")
//                    })
//                }
//                
//                destVc.friendNames = self.passThis
//            })
//
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = chosenImage
        
        storeImageToFirebase(image: chosenImage)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func grabProfileData(completed: downloadComplete) {
        let ref = BASE_URL.child("Users").child(USER_ID!)
        
        ref.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("profileImage") {

//                let imageRef = STORAGE_URL.child("users").child(USER_ID!).child("profileImage")
//                imageRef.downloadURL(completion: { (url, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        let imageUrl = url
//                        self.profileImage.sd_setImage(with: imageUrl)
//                    }
//                })
//
//                
                let picData = snapshot.value as? Dictionary<String, String>
                print("DATA: \(picData)")
                let userData = FirebaseData(profileData: picData!)
                if let imgUrl = picData?["profileImage"] {
                    DataServices.ds.userImageUrl = imgUrl
                    self.profileImage.loadImageFromCache(urlString: imgUrl)
                }
                self.userHobby.text = userData.userHobby
                self.userName.text = userData.userName
                self.userPinCount.text = "\(userData.pinCount) \n Pins"
                self.userFollowingCount.text = "\(userData.followingCount) \n Following"
                DataServices.ds.loggedInUsername = userData.userName
                DataServices.ds.userPinCount = Int(userData.pinCount)
                DataServices.ds.userFollowingCount = Int(userData.followingCount)

            }
            
        })
        
        completed()
    }
    
    func storeImageToFirebase(image: UIImage) {
        var data = Data()
        let uuid = NSUUID().uuidString
        data = UIImageJPEGRepresentation(image, 0.8)!
        let filePath = STORAGE_URL.child("users").child(USER_ID!).child("profileImage").child(uuid)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        filePath.put(data, metadata: metaData) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                let downloadUrl = metadata!.downloadURL()!.absoluteString
                BASE_URL.child("Users").child(USER_ID!).updateChildValues(["profileImage" : downloadUrl])
            }
        }
    }
    
//    func grabPostInfo(complete: @escaping downloadComplete) {
//        
//        let ref = BASE_URL.child("Posts").child(USER_ID!)
//        
//        ref.observe(.value, with: { (snapshot) in
//            let eachPost = snapshot.children
////            self.feedDetails = []
//            
//            for post in eachPost {
//                let data = post as! FIRDataSnapshot
//                let postInfo = data.value as? Dictionary<String, String>
//                let completePost = FirebaseData(postData: postInfo!)
//                
//                let urlString = completePost.mediaUrl
//                let url = URL(string: urlString)
//                let mediaData = NSData(contentsOf: url!)
//                let newImage = UIImage(data: mediaData as! Data)
//                
//                DataServices.ds.feedInfo.append(completePost)
////                self.theImages.append(newImage!)
//                
////                self.feedDetails.append(completePost)
//                print("BBB\(completePost.postDate)")
//            }
//            complete()
//            
//        })
//    }
}
