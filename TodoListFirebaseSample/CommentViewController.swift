//
//  CommentViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 31.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseInstanceID

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    var commentsArray = [Comment]()
    var selectedPost: Posts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePost()
        
        let commentRef = self.selectedPost.ref!.child("comments") //post comment
        commentRef.observeEventType(.Value, withBlock: { (snapshot) in
            
            var newItems = [Comment]()
            
            for item in snapshot.children {
                
                let newTodo = Comment(snapshot: item as! FIRDataSnapshot)
                newItems.insert(newTodo, atIndex: 0)
                
            }
            self.commentsArray = newItems
            self.tableview.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }
    
    func configurePost(){
        
        username.text = selectedPost.username
        postContent.text = selectedPost.content
        
        storageRef = FIRStorage.storage().referenceForURL(selectedPost.userImageStringUrl)
        storageRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data {
                        self.userImage.image = UIImage(data: data)
                    }
                    
                })
                
                
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
        
        
        let storageRef2 = FIRStorage.storage().referenceForURL(selectedPost.postImageStringUrl)
        storageRef2.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data {
                        self.postImage.image = UIImage(data: data)
                    }
                    
                })
                
                
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
        
        
    }

    @IBAction func addCommentAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Comment", message: "Add a new comment", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Add a new comment"
        }
        
        let sendCommentAction = UIAlertAction(title: "Comment", style: .Default) { (action) in
            let textfield = alertController.textFields!.first!
            
            let comment = Comment(postId: self.selectedPost.postId, userImageStringUrl: String(FIRAuth.auth()!.currentUser!.photoURL!), content: textfield.text!, username: FIRAuth.auth()!.currentUser!.displayName!)
            
            let commentRef = self.selectedPost.ref!.child("comments").childByAutoId()
            
            commentRef.setValue(comment.toAnyObject())
            
        }
        
        FIRInstanceID.instanceID().getIDWithHandler { (string, error) in
            print(string)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(sendCommentAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CommentTableViewCell
        
        // Configure the cell...
        
        cell.username.text = commentsArray[indexPath.row].username
        cell.commentLabel.text = commentsArray[indexPath.row].content
        
        storageRef = FIRStorage.storage().referenceForURL(commentsArray[indexPath.row].userImageStringUrl)
        storageRef.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
            
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data {
                        cell.userImage.image = UIImage(data: data)
                    }
                    
                })
                
                
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
        
        return cell
    }
}
