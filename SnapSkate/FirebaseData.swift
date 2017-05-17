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
    private var _pinCount: String!
    private var _followingCount: String!
    
    private var _postDesc: String!
    private var _postDate: String!
    private var _postedBy: String!
    private var _userImageUrl: String!
    private var _mediaUrl: String!
    private var _likes: String!
    private var _postId: String!
    private var _userId: String!
    
    private var _friendImageUrl: String!
    private var _friendName: String!
    
    private var _message: String!
    private var _commentDate: String!
    private var _commentImgUrl: String!
    
    var userName: String {
        return _userName
    }
    
    var userHobby: String {
        return _userHobby
    }
    
    var profileImageUrl: String {
        return _profileImageUrl
    }
    
    var pinCount: String {
        return _pinCount
    }
    
    var followingCount: String {
        return _followingCount
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
    
    var friendImageUrl: String {
        return _friendImageUrl
    }
    
    var friendName: String {
        return _friendName
    }
    
    var commentDate: String {
        return _commentDate
    }
    
    var message: String {
        return _message
    }
    
    var commentImgUrl: String {
        return _commentImgUrl
    }
    
    init(profileData: Dictionary<String, String>) {
        
        if let username = profileData["Username"] {
            self._userName = username
        }
        
        if let hobbyName = profileData["Hobby"] {
            self._userHobby = hobbyName
        }
        
        if let pins = profileData["skatePinCount"] {
            self._pinCount = pins
        } else {
            self._pinCount = "0"
        }
        
        if let following = profileData["followingCount"] {
            self._followingCount = following
        } else {
            self._followingCount = "0"
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
    
    init(friendListData: Dictionary<String, String>,friendId: String) {
        self._postedBy = friendId
        
        if let img = friendListData["profileImage"] {
            self._friendImageUrl = img
        }
        
        if let name = friendListData["Username"] {
            self._friendName = name
        }
        
        if let pins = friendListData["skatePinCount"] {
            self._pinCount = pins
        } else {
            self._pinCount = "0"
        }
    }
    
    init(commentData: Dictionary<String, String>) {
        if let date = commentData["date"] {
            self._commentDate = date
        }
        
        if let mess = commentData["message"] {
            self._message = mess
        }
        
        if let imgUrl = commentData["posterImageUrl"] {
            self._commentImgUrl = imgUrl
        }
    }
}
