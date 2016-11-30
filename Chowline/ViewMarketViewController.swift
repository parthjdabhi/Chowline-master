//
//  ViewMarketViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Firebase

var brandString = ""
var dealString = ""
var priceString = ""
var foodNameString = ""

class ViewMarketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var marketNameLabel: UILabel!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    var foodChoice = "Dairy"
    
    var brandArray = [String]()
    var dealArray = [String]()
    var priceArray = [String]()
    var foodNameArray = [String]()
    
    var dairyArray = [String]()
    var meatsArray = [String]()
    var fruitsArray = [String]()
    var vegetablesArray = [String]()
    var foodArray: [Dictionary<String,AnyObject>] = []
    
    var theSwitch = "default"
    
    var foodDetail:Dictionary<String,AnyObject> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 125
        
        ref = FIRDatabase.database().reference()
        
        print(selectedSuperMarketName)
        
        ref.child("markets").child("\(selectedSuperMarketName)").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            self.marketNameLabel.text = snapshot.value!["userName"] as! String!
            for _ in snapshot.children {

            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {

        var keyEntries = [String]()
        
        ref.child("markets").child("\(selectedSuperMarketName)").child("specials").child("\(foodChoice)").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                for child in snapshot.children
                {
                    let snap = child as! FIRDataSnapshot
                    let snapKey = snap.key
                    keyEntries.append(snapKey)
                    let brands = snap.value!["brandName"] as! String!
                    let deals = snap.value!["dealEnds"] as! String!
                    let prices = snap.value!["price"] as! String!
                    let foods = snap.value!["foodName"] as! String!
                    self.brandArray.append(brands)
                    self.dealArray.append(deals)
                    self.priceArray.append(prices)
                    self.foodNameArray.append(foods)
                }
                self.tableView.reloadData()
            }
        )
    }
    
    @IBAction func dairyButton(sender: AnyObject) {
        foodChoice = "Dairy"
        //viewDidAppear(true)
        theSwitch = "0"
    }
    
    @IBAction func meatsButton(sender: AnyObject) {
        foodChoice = "Meats"
        //viewDidAppear(true)
        theSwitch = "1"
    }
    
    @IBAction func fruitsButton(sender: AnyObject) {
        foodChoice = "Fruits"
        //viewDidLoad()
        //viewDidAppear(true)
        theSwitch = "2"
    }
    
    @IBAction func vegetablesButton(sender: AnyObject) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ViewMarketCell
        
        cell.foodBrand.text = brandArray[indexPath.row]
        cell.foodName.text = foodNameArray[indexPath.row]
        cell.foodPrice.text = priceArray[indexPath.row]
        cell.foodExpiration.text = dealArray[indexPath.row]
        
        foodChoice = foodNameArray[indexPath.row]
        
        var price = priceArray[indexPath.row]
        price = price.stringByReplacingOccurrencesOfString("$", withString: "")
        
        if price != ""
        {
            cell.onBuyNowButtonTapped = {
                print("Price of product : ",price)
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PurchaseViewController") as! PurchaseViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! ViewMarketCell
        foodNameString = currentCell.foodName.text!
        brandString = currentCell.foodBrand.text!
        priceString = currentCell.foodPrice.text!
        dealString = currentCell.foodExpiration.text!
        
        //let next = self.storyboard?.instantiateViewControllerWithIdentifier("PurchaseViewController") as! PurchaseViewController!
        //self.navigationController?.pushViewController(next, animated: true)
    }
    
    func reverseString(string: String) -> String {
        return String(string.characters.reverse())
    }
}