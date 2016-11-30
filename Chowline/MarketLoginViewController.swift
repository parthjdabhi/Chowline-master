//
//  MarketLoginViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MarketLoginViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButton(sender: AnyObject) {
        let email = emailField.text!
        let password = passwordField.text!
        if email.isEmpty || password.isEmpty {
            CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Email or password is missing.")
        }
        else{
            CommonUtils.sharedUtils.showProgress(self.view, label: "Signing in...")
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                dispatch_async(dispatch_get_main_queue(), {
                    CommonUtils.sharedUtils.hideProgress()
                })
                if let error = error {
                    CommonUtils.sharedUtils.showAlert(self, title: "Error", message: error.localizedDescription)
                    print(error.localizedDescription)
                }
                else{
                    let next = self.storyboard?.instantiateViewControllerWithIdentifier("MarketMainViewController") as! MarketMainViewController!
                    self.navigationController?.pushViewController(next, animated: true)
                }
            }
        }
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("MarketRegisterViewController") as! MarketRegisterViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextFieldWithConfigurationHandler(nil)
        prompt.addAction(okAction)
        presentViewController(prompt, animated: true, completion: nil);
    }
    
    func signedIn(user: FIRUser?) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("MarketMainViewController") as! MarketMainViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }

}
