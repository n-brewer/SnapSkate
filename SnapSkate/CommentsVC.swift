//
//  CommentsVC.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 5/8/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var commentField: UITextField!
    
    var desc: String!
    var messageArray = [String]()
    var dateArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        getPostComments()
//        descLbl.text = desc
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 140

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsCell
        
        let eachComment = messageArray[indexPath.row]
        let eachDate = dateArray[indexPath.row]
        cell.dateLbl.text = eachDate
        cell.commentField.text = eachComment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTapped(_ sender: UIButton) {
        addComment()
        commentField.text = ""
    }
    
    func addComment() {
        let ref = BASE_URL.child("Comments").child(desc)
        
        let date = NSDate().timeIntervalSince1970
        let currentDate = dateFormatter(timeInterval: date)
        
        let commentInfo: Dictionary<String, String> = [
            "date" : currentDate,
            "message": commentField.text!,
            "postedBy": USER_ID!
        ]
        
        ref.childByAutoId().setValue(commentInfo)
        
    }
    
    func getPostComments() {
        let ref = BASE_URL.child("Comments").child(desc)
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.messageArray = []
                let allComments = snapshot.children
                for comment in allComments {
                    let data = comment as! FIRDataSnapshot
                    let commentInfo = data.value as? Dictionary<String, String>
                    let mess = commentInfo?["message"]
                    let dateTime = commentInfo?["date"]
                    self.dateArray.append(dateTime!)
                    self.messageArray.append(mess!)

                }
                self.tableview.reloadData()
            } else {
                print("NO COMMENTS YET")
            }
        })
    
    }
    
    func dateFormatter(timeInterval: TimeInterval) -> String {
        let currentDate = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: currentDate as Date)

        return dateString
    }

}
