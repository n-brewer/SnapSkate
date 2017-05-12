//
//  FirebaseData.swift
//  SnapSkate
//
//  Created by Nathan Brewer on 3/12/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import Firebase

class FirebaseData {
    
    private var _userName: String!
    private var _userHobby: String!
    private var _profileImageUrl: String!
    
    private var _postDesc: String!
    private var _postDate: String!
    private var _postedBy: String!
    private var _userImageUrl: String!
    private var _mediaUrl: String!
    private var _likes: String!
    private var _postId: String!
    private var _userId: String!
    
    var userName: String {
        return _userName
    }
    
    var userHobby: String {
        return _userHobby
    }
    
    var profileImageUrl: String {
        return _profileImageUrl
    }
    
    
    var postDesc: String {
        return _postDesc
    }
    
    var postDate: String {
        return _postDate
    }
    
    var postedBy: String {
        return _postedBy
    }
    
    var userImageUrl: String {
        return _userImageUrl
    }
    
    var mediaUrl: String {
        return _mediaUrl
    }
    
    var likes: String {
        return _likes
    }
    
    var postId: String {
        return _postId
    }
    
    var userId: String {
        return _userId
    }
    
    init(profileData: Dictionary<String, String>) {
        
        if let username = profileData["Username"] {
            self._userName = username
        }
        
        if let hobbyName = profileData["Hobby"] {
            self._userHobby = hobbyName
        }
    }
    
    init(userId: String, postKey: String , postData: Dictionary<String, String>) {
        self._postId = postKey
        self._userId = userId
        
        if let desc = postData["postDescription"] {
            self._postDesc = desc
        }
        
        if let date = postData["postDate"] {
            self._postDate = date
        }
        
        if let user = postData["postedBy"] {
            self._postedBy = user
        }
        
        if let userImgUrl = postData["userImageUrl"] {
            self._userImageUrl = userImgUrl
        }
        
        if let mediaUrl = postData["postImageUrl"] {
            self._mediaUrl = mediaUrl
        }
        
        if let like = postData["likes"] {
            self._likes = like
        }
        
    }
}
