//
//  MarketRegisterViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class MarketRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var zipField: UITextField!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.addressField.delegate = self
        self.cityField.delegate = self
        self.zipField.delegate = self
        self.stateField.delegate = self
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
                    self.ref.child("markets").child(user!.uid).setValue(["userName": self.nameField.text!, "email": email, "address": self.addressField.text!, "city": self.cityField.text!, "state": self.stateField.text!, "zip": self.zipField.text!])
                    self.reverseGeocodeLocation()
                    CommonUtils.sharedUtils.hideProgress()
                    let photoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MarketMainViewController") as! MarketMainViewController!
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
    
    func reverseGeocodeLocation() {
        let address = "\(addressField.text!) \(cityField.text!), \(stateField.text!), USA"
        let geocoder = CLGeocoder()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                coordinates.latitude
                coordinates.longitude
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
                self.ref.child("markets").child(userID!).updateChildValues(["lat": coordinates.latitude, "long": coordinates.longitude])
            }
        })
    }
}
