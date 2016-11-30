//
//  PostFoodViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Firebase

class PostFoodViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var foodName: UITextField!
    @IBOutlet var foodType: UITextField!
    @IBOutlet var brandName: UITextField!
    @IBOutlet var thePrice: UITextField!
    @IBOutlet var dealEnds: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var values = ["Dairy", "Meats", "Fruits", "Vegetables"]
    let cellReuseIdentifier = "cell"
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
        tableView.delegate = self
        tableView.dataSource = self
        foodType.delegate = self
        
        tableView.hidden = true
        
        foodType.addTarget(self, action: #selector(textFieldActive), forControlEvents: UIControlEvents.TouchDown)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postFood(sender: AnyObject) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
         ref.child("markets").child(userID!).child("specials").child("\(foodType.text!)").childByAutoId().updateChildValues(["brandName": brandName.text!, "foodName": foodName.text!, "price": "$\(thePrice.text!)", "dealEnds": dealEnds.text!])
         navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLayoutSubviews()
    {
        // Assumption is we're supporting a small maximum number of entries
        // so will set height constraint to content size
        // Alternatively can set to another size, such as using row heights and setting frame
        heightConstraint.constant = tableView.contentSize.height
    }
    
    // Manage keyboard and tableView visibility
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
        if touch.view != tableView
        {
            foodType.endEditing(true)
            tableView.hidden = true
        }
    }
    
    // Toggle the tableView visibility when click on textField
    func textFieldActive() {
        tableView.hidden = !tableView.hidden
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
        print("The textField ended editing. Do something based on app requirements.")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        // Set text from the data model
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.font = foodType.font
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        foodType.text = values[indexPath.row]
        tableView.hidden = true
        foodType.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    

}
