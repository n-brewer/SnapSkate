//
//  ImagesCVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/25/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

private let reuseIdentifier = "imageCell"

class ImagesCVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesArray = [String]()
    var picturesArray = [UIImage]()
    var chosenSpot = String()
    var enlargedImage : UIImageView!
    var startingTouch: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(chosenSpot)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        grabImageUrls()
        collectionView.reloadData()
//        print(annotationDetails?.locationName ?? "Didnt work...")

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            self.startingTouch = position
            print("JJ \(self.startingTouch)")
            self.collectionView.reloadData()
            
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picturesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagesCell
//        let eachImage = imagesArray[indexPath.row]
        let img = picturesArray[indexPath.item]
        
//        cell.configureCell(imageUrl: eachImage)
        cell.designCell(img: img)
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagesCell
        let selectedImage = picturesArray[indexPath.item]
        fullSizeImage(img: selectedImage)
//        if let url = URL(string: selectedImage) {
//            if let imageData = NSData(contentsOf: url) {
//                let img = UIImage(data: imageData as Data)
//                fullSizeImage(img: img!)
//            }
//        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 8.0, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.enlargedImage.frame.origin = CGPoint(x: 0.0, y: 0.0)
            self.enlargedImage.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)

        
    }
    
    func grabImageUrls() {
        let ref = BASE_URL.child("skateSpotImages").child(chosenSpot)
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let allImages = snapshot.children
                print("ALL IMAGES \(allImages)")
                
                for eachImage in allImages {
                    let data = eachImage as! FIRDataSnapshot
                    print("DATA \(data)")
                    let value = data.value as! Dictionary<String, String>
////                    let id = data.key
                    let imageUrl = SkateSpot(imgUrlDict: value)
                    let urlString = imageUrl.imageUrl
                    print("VALUE \(urlString)")
//                    let storageRef = FIRStorage.storage().reference(forURL: url)
                    
                    let url = URL(string: urlString)
                    let imageData = NSData(contentsOf: url!)
                    let pic = UIImage(data: imageData as! Data)
                    self.picturesArray.append(pic!)
//                    storageRef.data(withMaxSize: 1 * 2024 * 2024, completion: { (data, error) in
//                        if error != nil {
//                            print(error?.localizedDescription)
//                        } else {
//                            let pic = UIImage(data: data!)
//                            
//                            self.picturesArray.append(pic!)
//                            self.collectionView.reloadData()
//                        }
//                    })
//                    self.imagesArray.append(urlString)
//                    print("IMAGEURL \(self.imagesArray[0])")
//
//                    self.imagesArray.append(imageUrl)
                }
            }
            
        })
    }
    
    func downloadImageFromFirebase() {
        let ref = BASE_URL.child("skateSpotImages").child(chosenSpot)
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                
            }
        })
    }
    
    func fullSizeImage(img: UIImage) {
        enlargedImage = UIImageView(image: img)
        enlargedImage.frame.size = CGSize(width: 0.0, height: 0.0)
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
            sender.view?.frame = CGRect(origin: self.startingTouch!, size: CGSize(width: 0.0, height: 0.0))
        }, completion: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
