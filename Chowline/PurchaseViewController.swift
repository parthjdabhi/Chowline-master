//
//  PurchaseViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/17/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit

import Stripe
import Alamofire
import SwiftyJSON

class PurchaseViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet var cardTextField: STPPaymentCardTextField!
    @IBOutlet var btnCheckout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        print(foodNameString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCheckout(sender: UIButton) {
        if cardTextField.isValid == false {
           CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "Invalid payment details!")
        } else if Stripe.defaultPublishableKey() == nil {
            CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "Please specify a Stripe Publishable Key")
        }
        else {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Loading..")
            STPAPIClient.sharedClient().createTokenWithCard(cardTextField.cardParams, completion: { (token:STPToken?, error:NSError?) in
                CommonUtils.sharedUtils.hideProgress()
                if let err = error {
                    print(err)
                    CommonUtils.sharedUtils.showAlert(self, title: "Message", message: err.debugDescription)
                } else {
                    print(token.debugDescription)
                    
                    //stripe_token=%@&amount=%@
                    //http:// ecreateinfotech.info/Chowlin/payment.php
                    
                    
                    let Parameters:[String : AnyObject] = ["submitted" : "1",
                        "stripe_token" : token?.tokenId ?? "",
                        "amount" : 500]
                    print(Parameters)
                    //SVProgressHUD.showWithStatus("Processing..")
                    CommonUtils.sharedUtils.showProgress(self.view, label: "Processing..")
                    Alamofire.request(.POST, "http://ecreateinfotech.info/Chowlin/payment.php", parameters: Parameters)
                        .validate()
                        .responseJSON { response in
                            CommonUtils.sharedUtils.hideProgress()
                            
                            print(response.result)
                            
                            switch response.result
                            {
                            case .Success(let data):
                                let json = JSON(data)
                                print(json.dictionary)
                                
                                if let status = json["status"].string
                                    where status == "1"
                                {
                                    print(json["msg"].string )
                                    //SVProgressHUD.showSuccessWithStatus(json["message"].string ?? "Login successfully")
                                    CommonUtils.sharedUtils.showAlert(self, title: "Message", message: json["message"].string ?? "Payment successfully")
                                    
                                    //Go To Main Screen after purchase
                                    //self.performSegueWithIdentifier("segueHome", sender: nil)
                                }
                                else if let msg = json["msg"].string {
                                    print(msg)
                                    //SVProgressHUD.showErrorWithStatus(msg)
                                    CommonUtils.sharedUtils.showAlert(self, title: "Message", message: msg)
                                    self.navigationController?.popViewControllerAnimated(true)
                                } else {
                                    //SVProgressHUD.showErrorWithStatus("Unable to process payment!")    // error?.localizedDescription
                                    CommonUtils.sharedUtils.showAlert(self, title: "Message", message: "Unable to process payment!")
                                }
                                
                            case .Failure(let error):
                                //SVProgressHUD.showErrorWithStatus("Request failed!")
                                CommonUtils.sharedUtils.showAlert(self, title: "Error", message: "Request failed!")
                                print("Request failed with error: \(error)")
                                //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                            }
                    }
                    
                }
                
            })
        }
    }

}

