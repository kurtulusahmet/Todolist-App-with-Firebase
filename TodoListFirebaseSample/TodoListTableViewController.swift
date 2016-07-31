//
//  TodoListTableViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 23.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID
import FirebaseMessaging

class TodoListTableViewController: UITableViewController {

    var todoArray = [Todo]()
    
    var posts = [Posts]()
    
    var databaseRef: FIRDatabaseReference!
    
    var storageRef: FIRStorageReference!
    
    var segmentedControl: HMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl = HMSegmentedControl(sectionTitles: ["Todo","Posts"])
        segmentedControl.frame = CGRectMake(10, 10, 300, 60)
        segmentedControl.selectionIndicatorColor = UIColor.orangeColor()
        segmentedControl.backgroundColor = UIColor.groupTableViewBackgroundColor()
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        segmentedControl.addTarget(self, action: #selector(TodoListTableViewController.segmentedAction), forControlEvents: UIControlEvents.ValueChanged)
        tableView.tableHeaderView = segmentedControl
        
        if segmentedControl.selectedSegmentIndex == 1 {
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 252
        }
    }
    
    // MARK: - Table view data source
    
    
    func segmentedAction(){
        
        if segmentedControl.selectedSegmentIndex == 0 {
            databaseRef = FIRDatabase.database().reference().child("allTodos")
            
            
            
            
            databaseRef.observeEventType(.Value, withBlock: { (snapshot) in
                
                var newItems = [Todo]()
                
                for item in snapshot.children {
                    
                    let newTodo = Todo(snapshot: item as! FIRDataSnapshot)
                    newItems.insert(newTodo, atIndex: 0)
                    
                }
                self.todoArray = newItems
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }else {
            
            let postRef = FIRDatabase.database().reference().child("posts")
            
            postRef.observeEventType(.Value, withBlock: { (snapshot) in
                var newPosts = [Posts]()
                
                for post in snapshot.children{
                    
                    let post = Posts(snapshot: post as! FIRDataSnapshot)
                    
                    newPosts.insert(post, atIndex: 0)
                    
                }
                
                self.posts = newPosts
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                
                }, withCancelBlock: { (error) in
                    print(error.localizedDescription)
                    
            })
        }
        
        
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberOfRows = 0
        
        switch segmentedControl.selectedSegmentIndex{
            
        case 0: numberOfRows = todoArray.count
            
        case 1: numberOfRows = posts.count
            
        default: break
        }
        
        return numberOfRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TodoTableViewCell
            
            // Configure the cell...
            cell.todoSummaryLabel.text = todoArray[indexPath.row].title
            cell.todoDescriptionTextview.text = todoArray[indexPath.row].content
            cell.usernameLabel.text = todoArray[indexPath.row].username
            cell.todoColorView.backgroundColor = UIColor(red: todoArray[indexPath.row].red, green: todoArray[indexPath.row].green, blue: todoArray[indexPath.row].blue, alpha: 1.0)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PCell", forIndexPath: indexPath) as! PostTableViewCell
            cell.username.text = posts[indexPath.row].username
            cell.postContent.text = posts[indexPath.row].content
            
            storageRef = FIRStorage.storage().referenceForURL(posts[indexPath.row].userImageStringUrl)
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
            
            
            
            let storageRef2 = FIRStorage.storage().referenceForURL(posts[indexPath.row].postImageStringUrl)
            storageRef2.dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let data = data {
                            cell.postImage.image = UIImage(data: data)
                        }
                        
                    })
                    
                    
                }else {
                    print(error!.localizedDescription)
                    
                }
            })

            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 134
        }else {
            return 252
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        if ((FIRAuth.auth()?.currentUser) == nil){
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(vc, animated: true, completion: nil)
            
            
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            databaseRef = FIRDatabase.database().reference().child("allTodos")
            
            databaseRef.observeEventType(.Value, withBlock: { (snapshot) in
                
                var newItems = [Todo]()
                
                for item in snapshot.children {
                    
                    let newTodo = Todo(snapshot: item as! FIRDataSnapshot)
                    newItems.insert(newTodo, atIndex: 0)
                    
                }
                self.todoArray = newItems
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let ref = todoArray[indexPath.row].ref
            ref!.removeValue()
            todoArray.removeAtIndex(indexPath.row)
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("updateTodo", sender: self)}
        else {
            performSegueWithIdentifier("addComment", sender: self)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if segue.identifier == "updateTodo" {
                
                let vc = segue.destinationViewController as! UpdateViewController
                let indexPath = tableView.indexPathForSelectedRow!
                
                vc.todo = todoArray[indexPath.row]
            }
        }else {
            if segue.identifier == "addComment" {
                
                let vc = segue.destinationViewController as! CommentViewController
                let indexPath = tableView.indexPathForSelectedRow!
                
                vc.selectedPost = posts[indexPath.row]
            }
            
        }
    }

}
