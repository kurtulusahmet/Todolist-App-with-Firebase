//
//  Todo.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 28.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Todo {
    
    var title: String!
    var content: String!
    var username: String!
    var red: CGFloat!
    var blue: CGFloat!
    var green: CGFloat!
    var ref: FIRDatabaseReference!
    var key: String!
    
    init(title: String,content: String,username: String,red: CGFloat,blue: CGFloat,green: CGFloat,key: String = ""){
        self.title = title
        self.content = content
        self.username = username
        self.red = red
        self.blue = blue
        self.green = green
        self.key = key
        self.ref = FIRDatabase.database().reference()
        
    }
    
    init(snapshot: FIRDataSnapshot){
        
        self.title = snapshot.value!["title"] as! String
        self.content = snapshot.value!["content"] as! String
        self.username = snapshot.value!["username"] as! String
        self.red = snapshot.value!["red"] as! CGFloat
        self.blue = snapshot.value!["blue"] as! CGFloat
        self.green = snapshot.value!["green"] as! CGFloat
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        
    }
    
    func toAnyObject() -> [String: AnyObject] {
        
        return ["title": title, "content": content,"username": username,"blue": blue,"red": red,"green": green]
    }
    
}
