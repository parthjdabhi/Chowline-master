//
//  ViewFoodCell.swift
//  Chowline
//
//  Created by Dustin Allen on 11/14/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class ViewFoodCell: UITableViewCell {
    
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodBrand: UILabel!
    @IBOutlet var foodPrice: UILabel!
    @IBOutlet var foodExpiration: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
