//
//  ViewMarketCell.swift
//  Chowline
//
//  Created by Dustin Allen on 11/15/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class ViewMarketCell: UITableViewCell {
    
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodBrand: UILabel!
    @IBOutlet var foodPrice: UILabel!
    @IBOutlet var foodExpiration: UILabel!
    
    
    @IBOutlet var btnBuyNow: UIButton!
    
    var onBuyNowButtonTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actionBuyNowTapped(sender: UIButton) {
        if let onBuyNowButtonTapped = self.onBuyNowButtonTapped {
            onBuyNowButtonTapped()
        }
    }
}
