//
//  FeedVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 4/6/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var dislikeCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    var feedDetails = [FirebaseData]()
    var theImages = [UIImage]()
    var enlargedImage: UIImageView!
    var tappedPicture: UIImage!
    var selectedButton: Int!
    
    var following: Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self

        grabPostInfo {
            self.tableview.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        let buttonRow = sender.tag
        
        let likedPost = feedDetails[buttonRow]
        var currentCount: Int = likedPost.likes as! Int
        let newCount = currentCount + 1
        
        
    }
    
    @IBAction func commentsTapped(_ sender: UIButton) {
        
        selectedButton = sender.tag
        performSegue(withIdentifier: "toComments", sender: self)
//        let view = UIView(frame: CGRect(x: sender.center.x, y: (sender.center.y) / 2 , width: 100, height: 100))
//        view.backgroundColor = UIColor.blue
//        self.tableview.addSubview(view)
        
    }
    
    @IBAction func followBtnTapped(_ sender: UIButton) {
        let rowInArray = sender.tag
        let pickedRow = feedDetails[rowInArray]
        let followId = pickedRow.userId
        
        followThis(person: followId)
        
        print(followId)
    }
    
    func followThis(person: String) {
        let ref = BASE_URL.child("Following").child(USER_ID!)
        
        let following: Dictionary<String, Bool> = [
            "followingUser" : true
        ]
        
        ref.child(person).setValue(following)
        tableview.reloadData()
    }
    
    func checkForFollowing(who: String, buttonStatus: UIButton) {
        let ref = BASE_URL.child("Following").child(USER_ID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(who) {
                print("TTT")
                buttonStatus.backgroundColor = UIColor.green
                buttonStatus.setTitle("Following", for: .normal)
            } else {
                print("NNN")
                buttonStatus.backgroundColor = UIColor.red
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            let commentsVC = segue.destination as! CommentsVC
            let item = feedDetails[self.selectedButton]
            print("TESTING \(item.postId)")
            commentsVC.desc = item.postId
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedDetails.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? FeedCell {
            
//            let imageSelected = self.theImages[indexPath.row]
//            fullSizeImage(img: imageSelected)
        
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//        let selectedRow = feedDetails[indexPath.row]
//        let selectedImageUrlString = selectedRow.mediaUrl
//        let url = URL(string: selectedImageUrlString)
//        let imageData = NSData(contentsOf: url!)
//        let pic = UIImage(data: imageData as! Data)
//        self.tappedPicture = pic
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? FeedCell {
            
            let eachPost = feedDetails[indexPath.row]
            
            self.checkForFollowing(who: eachPost.userId, buttonStatus: cell.followBtn)
            
            cell.configureCell(data: eachPost)
            cell.commentsBtn.tag = indexPath.row
            cell.followBtn.tag = indexPath.row
            
            let feedImageUrl = eachPost.mediaUrl
            let userImgUrl = eachPost.userImageUrl
            cell.posterImage.loadImageFromCache(urlString: userImgUrl)
            cell.postImage.loadImageFromCache(urlString: feedImageUrl)

//            fullSizeImage(img: tester)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func grabPostInfo(complete: @escaping downloadComplete) {
        
        let ref = BASE_URL.child("Posts")
//            .child(USER_ID!)
        
        ref.observe(.value, with: { (snapshot) in
//            let eachPost = snapshot.children
            let userPosts = snapshot.children
            self.feedDetails = []
            for post in userPosts {
                let data = post as! FIRDataSnapshot
                let uid = data.key
                
                let more = data.children.allObjects as! [FIRDataSnapshot]
                
                for detail in more {
                    let pkey = detail.key
                    let spec = detail.value as! Dictionary<String, String>
                    print("AAAS \(spec)")
                    
                    let completePost = FirebaseData(userId: uid, postKey: pkey, postData: spec)
                    self.feedDetails.append(completePost)
                    
//                    let urlString = completePost.mediaUrl
//                    let url = URL(string: urlString)
//                    let mediaData = NSData(contentsOf: url!)
//                    let newImage = UIImage(data: mediaData as! Data)
//                    
//                    self.theImages.append(newImage!)
                    
                    print("BBB\(userPosts)")
                    
                }
            }

            complete()
            
        })
    }
    
    func fullSizeImage(img: UIImage) {
        enlargedImage = UIImageView(image: img)
        enlargedImage.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        enlargedImage.center = self.view.center
        enlargedImage.backgroundColor = .black
        enlargedImage.contentMode = .scaleAspectFit
        enlargedImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(sender:)))
        enlargedImage.addGestureRecognizer(tap)
        self.view.addSubview(enlargedImage)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 8.0, initialSpringVelocity: 3.0, options: .curveEaseIn, animations: {
            sender.view?.frame = CGRect(origin: self.view.center, size: CGSize(width: 0.0, height: 0.0))
        }, completion: nil)
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageFromCache(urlString: String){
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        
                        self.image = downloadedImage
                    }
                })
                
            }
        }).resume()
    }
    
}





