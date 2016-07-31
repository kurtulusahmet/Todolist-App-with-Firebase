//
//  Comment.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 31.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct Comment {
    var userImageStringUrl: String!
    var postId: String!
    var content: String!
    var username: String!
    var ref: FIRDatabaseReference?
    var key: String!
    
    
    init(postId: String, userImageStringUrl: String, content: String, username: String, key: String = ""){
        
        self.content = content
        self.postId = postId
        self.username = username
        self.userImageStringUrl = userImageStringUrl
        self.ref = FIRDatabase.database().reference()
        
        
    }
    
    init(snapshot: FIRDataSnapshot){
        
        self.content = snapshot.value!["content"] as! String
        self.postId = snapshot.value!["postId"] as! String
        
        self.username = snapshot.value!["username"] as! String
        self.userImageStringUrl = snapshot.value!["userImageStringUrl"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        
        return ["userImageStringUrl": userImageStringUrl, "content": content,"username": username,"postId":postId]
    }
    
    
}
