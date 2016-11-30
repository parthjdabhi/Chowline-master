//
//  InitialViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func foodMarketLogin(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("MarketLoginViewController") as! MarketLoginViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func foodCustomerLogin(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
}
