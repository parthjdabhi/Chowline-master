//
//  MarketMainViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MarketMainViewController: UIViewController {
    
    @IBOutlet var welcomeLabel: UILabel!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("markets").child(userID!).observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            
            if let welcome = snapshot.value!["userName"] {
                self.welcomeLabel.text = "Welcome \(welcome as! String!)"
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButton(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        AppState.sharedInstance.signedIn = false
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InitialViewController") as! InitialViewController!
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func postFoodButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("PostFoodViewController") as! PostFoodViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func viewFoodButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("ViewFoodViewController") as! ViewFoodViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func viewBalanceFood(sender: AnyObject) {
        
    }
    
    @IBAction func settingsButton(sender: AnyObject) {
        
    }
    
}
