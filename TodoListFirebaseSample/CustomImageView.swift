//
//  CustomImageView.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 24.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit

@IBDesignable class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : CGColor = UIColor.blackColor().CGColor {
        
        didSet{
            layer.borderColor = borderColor
        }
    }

}
