//
//  ViewFoodViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
//import Stripe

class ViewFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var marketName: UILabel!
    
    let cellReuseIdentifier = "cell"
    
    var foodChoice = ""
    var theNameArray = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var theBrandArray = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var theDealArray = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var thePriceArray = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var availableProducts = []
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 125
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("markets").child(userID!).child("specials").child("Dairy").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                if userID != snap.key {
                    let theName = snap.value!["foodName"] as! String!
                    let theBrand = snap.value!["brandName"] as! String!
                    let theDeal = snap.value!["dealEnds"] as! String!
                    let thePrice = snap.value!["price"] as! String!
                    self.theNameArray.append(theName)
                    self.theBrandArray.append(theBrand)
                    self.theDealArray.append(theDeal)
                    self.thePriceArray.append(thePrice)
                    print(self.theNameArray)
                    print(self.theBrandArray)
                    print(self.thePriceArray)
                    print(self.theDealArray)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            });
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("markets").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            
            self.marketName.text = snapshot.value!["userName"] as! String!
            print("Market Name: \(self.marketName)")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("theCell", forIndexPath: indexPath) as! ViewFoodCell
        
        cell.foodBrand.text = theBrandArray[indexPath.row]
        cell.foodName.text = theNameArray[indexPath.row]
        cell.foodPrice.text = thePriceArray[indexPath.row]
        cell.foodExpiration.text = theDealArray[indexPath.row]
        
        //foodChoice = foodNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theBrandArray.count
    }
}
