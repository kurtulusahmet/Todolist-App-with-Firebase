//
//  MyProfileViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 25.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        if FIRAuth.auth()?.currentUser != nil {
            
            do {
                
                try  FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                presentViewController(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

}
