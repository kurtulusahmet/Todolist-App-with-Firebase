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
    
    var databaseRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TodoTableViewCell

        // Configure the cell...
        cell.todoSummaryLabel.text = todoArray[indexPath.row].title
        cell.todoDescriptionTextview.text = todoArray[indexPath.row].content
        cell.usernameLabel.text = todoArray[indexPath.row].username
        cell.todoColorView.backgroundColor = UIColor(red: todoArray[indexPath.row].red, green: todoArray[indexPath.row].green, blue: todoArray[indexPath.row].blue, alpha: 1.0)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
