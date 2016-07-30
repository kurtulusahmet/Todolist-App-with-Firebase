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
import FirebaseDatabase
import FirebaseStorage

class MyProfileViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userImageView: CustomImageView!
    
    var urlImage : String!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            presentViewController(vc, animated: true, completion: nil)
        }else {
            databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)").observeEventType(.Value, withBlock: { (snapshot) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let user = User(snapshot: snapshot)
                    self.username.text = user.username
                    self.country.text = user.country
                    self.email.text = FIRAuth.auth()?.currentUser?.email
                    
                    let imageUrl = String(user.photoUrl)
                    
                    self.storageRef.referenceForURL(imageUrl).dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            if let data = data {
                                self.userImageView.image = UIImage(data: data)
                            }
                        }
                    })
                    
                    
                })
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }

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
    
    @IBAction func updateEmailAction(sender: UIButton) {
        if let user = FIRAuth.auth()?.currentUser {
            
            user.updateEmail(email.text!, completion: { (error) in
                if let error = error{
                    print(error.localizedDescription)
                }else {
                    let alertView = UIAlertView(title: "Update Email", message: "You have successfully updated your email", delegate: self, cancelButtonTitle: "OK, Thanks")
                    alertView.show()
                }
            })
        }
    }
    
    @IBAction func updatePasswordAction(sender: UIButton) {
        if let user = FIRAuth.auth()?.currentUser {
            
            user.updatePassword(password.text!, completion: { (error) in
                if let error = error{
                    print(error.localizedDescription)
                }else {
                    let alertView = UIAlertView(title: "Update Password", message: "You have successfully updated your password", delegate: self, cancelButtonTitle: "OK, Thanks")
                    alertView.show()
                    
                    
                    
                }
            })
        }
    }
    
    @IBAction func deleteAccount(sender: UIButton) {
        let user = FIRAuth.auth()?.currentUser
        user?.deleteWithCompletion({ (error) in
            if let error = error{
                print(error.localizedDescription)
            }else {
                let alertView = UIAlertView(title: "Delete Account", message: "You have successfully deleted your acoount. We are sorry to see you leaving us this way.", delegate: self, cancelButtonTitle: "OK, Thanks")
                alertView.show()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(vc, animated: true, completion: nil)
            }
        })
    }
    
    

}
