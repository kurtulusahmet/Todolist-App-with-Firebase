//
//  AddPostViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 29.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let data = UIImageJPEGRepresentation(self.postImage.image!, 0.5)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let postId = "\(FIRAuth.auth()!.currentUser!.uid)\(NSUUID().UUIDString)"
        let imagePath = "postImages\(postId)/postPic.jpg"
        
        storageRef.child(imagePath).putData(data!, metadata: metadata) { (metadata, error) in
            if error == nil {
                
                let postRef = self.databaseRef.child("posts").childByAutoId()
                let post = Posts(postImageStringUrl: String(metadata!.downloadURL()!), postId: postId, userImageStringUrl: String(FIRAuth.auth()!.currentUser!.photoURL!), content: self.postContent.text!, username: FIRAuth.auth()!.currentUser!.displayName!)
                postRef.setValue(post.toAnyObject())
                
                
            }else {
                print(error!.localizedDescription)
            }
        }
        
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func chooseImageAction(sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a picture", message: "Choose from", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            
            pickerController.sourceType = .Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .Default) { (action) in
            
            pickerController.sourceType = .PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        
        let savedPhotosAlbumAction = UIAlertAction(title: "Saved Photos Album", style: .Default) { (action) in
            
            pickerController.sourceType = .SavedPhotosAlbum
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAlbumAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.postImage.image = image
    }
}
