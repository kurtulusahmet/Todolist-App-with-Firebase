//
//  AddTodoViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 23.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddTodoViewController: UIViewController {

    @IBOutlet weak var todoDescription: UITextView!
    @IBOutlet weak var todoSummary: UITextField!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveAction(sender: UIBarButtonItem) {
        // Create Todo Reference in the Firebase Database
        let todoRef = databaseRef.child("allTodos").childByAutoId()
        
        //Create the colors for our Todo
        let red = CGFloat(arc4random_uniform(UInt32(255.5)))/255.5
        let blue = CGFloat(arc4random_uniform(UInt32(255.5)))/255.5
        let green = CGFloat(arc4random_uniform(UInt32(255.5)))/255.5
        
        var title =  String()
        if todoSummary.text == ""{
            
            todoSummary.text = "No item name"
            title = todoSummary.text!
        }else{
            
            title = todoSummary.text!
        }
        
        var content = String()
        
        if todoDescription.text == "" {
            todoDescription.text = "No description for this Todo"
            content = todoDescription.text!
        }else{
            content = todoDescription.text!
        }
        
        
        
        
        
        let todo = Todo(title: title, content: content, username: FIRAuth.auth()!.currentUser!.displayName!, red: red, blue: blue, green: green)
        
        todoRef.setValue(todo.toAnyObject())
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

}
