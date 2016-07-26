//
//  User.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 25.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {
    
    
    var username: String!
    var email: String!
    var photoUrl: String!
    var country: String!
    var ref: FIRDatabaseReference?
    var key: String
    
    init(snapshot: FIRDataSnapshot){ //FIRDataSnapshot -> get data
        
        key = snapshot.key
        username = snapshot.value!["username"] as! String
        email = snapshot.value!["email"] as! String
        photoUrl = snapshot.value!["photoUrl"] as! String
        country = snapshot.value!["country"] as! String
        ref = snapshot.ref
        
    }
    
}
