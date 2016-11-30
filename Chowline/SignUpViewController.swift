//
//  SignUpViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let email = self.emailField.text!
        let password = self.passwordField.text!
        
        if nameField.text != "" && emailField.text != "" && passwordField.text != "" {
            
            CommonUtils.sharedUtils.showProgress(self.view, label: "Registering...")
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion:  { (user, error) in
                if error == nil {
                    FIREmailPasswordAuthProvider.credentialWithEmail(email, password: password)
                    self.ref.child("users").child(user!.uid).setValue(["userName": self.nameField.text!, "email": email])
                    CommonUtils.sharedUtils.hideProgress()
                    let photoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController!
                    self.navigationController?.pushViewController(photoViewController, animated: true)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        CommonUtils.sharedUtils.hideProgress()
                        CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    })
                }
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter email & password!",   preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
        }
    }
}
