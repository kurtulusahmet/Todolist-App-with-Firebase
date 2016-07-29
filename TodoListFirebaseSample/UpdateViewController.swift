//
//  UpdateViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 29.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UpdateViewController: UIViewController {

    @IBOutlet weak var todoDescription: UITextView!
    @IBOutlet weak var todoSummary: UITextField!
    
    var todo: Todo!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        todoDescription.text = todo.content
        todoSummary.text = todo.title
    }
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        
        
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
        
        
        
        
        
        let updatedTodo = Todo(title: title, content: content, username: FIRAuth.auth()!.currentUser!.displayName!, red: todo.red, blue: todo.blue, green: todo.green)
        
        let key = todo.ref!.key
        
        let updateRef = databaseRef.child("/allTodos/\(key)")
        
        updateRef.updateChildValues(updatedTodo.toAnyObject())
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

}
