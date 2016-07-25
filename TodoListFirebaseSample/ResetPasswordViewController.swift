//
//  ResetPasswordViewController.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 23.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    let networkingService = NetworkingService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordAction(sender: UIButton) {
        networkingService.resetPassword(emailTextfield.text!)
    }
    

}
