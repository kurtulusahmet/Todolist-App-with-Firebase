//
//  SignUpViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 23.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userImageView: CustomImageView!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var countryTextfield: UITextField!
    
    
    var pickerView: UIPickerView!
    var countryArray = [String]()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for code in NSLocale.ISOCountryCodes() as [String] {
            let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
            let name = NSLocale(localeIdentifier: "tr_TR").displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for \(code)"
            
            countryArray.append(name)
            countryArray.sortInPlace({ (name1, name2) -> Bool in
                name1 < name2
            })
        }
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.lightGrayColor()
        countryTextfield.inputView = pickerView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissController(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func dismissController(gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextfield.text = countryArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: countryArray[row], attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        return title
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func choosePicture(sender: AnyObject) {
        
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
        self.userImageView.image = image
    }
    
    @IBAction func signUpAction(sender: UIButton) {
        
        let data = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        
        networkingService.signUp(emailTextfield.text!, username: usernameTextfield.text!, password: passwordTextfield.text!, country: countryTextfield.text!, data: data!)
    }

}
