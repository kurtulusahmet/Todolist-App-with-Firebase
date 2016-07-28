//
//  TodoTableViewCell.swift
//  TodoListFirebaseSample
//
//  Created by Kurtulus Ahmet on 28.07.2016.
//  Copyright © 2016 Kurtulus Ahmet. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoColorView: UIView!
    @IBOutlet weak var todoSummaryLabel: UILabel!
    @IBOutlet weak var todoDescriptionTextview: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        todoColorView.layer.cornerRadius = 10
    }

}
