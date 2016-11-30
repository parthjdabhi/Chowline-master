//
//  DropInViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/18/16.
//  Copyright © 2016 Harloch. All rights reserved.
//
/*
import UIKit
import Braintree

class DropInViewController: UIViewController, BTDropInViewControllerDelegate {
    
    var braintree: Braintree?
    
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod) {
        // ...
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        // ...
    }
}

class MyViewController: UIViewController, BTDropInViewControllerDelegate {
    
    // With this example, you should ensure that your users cannot tap the pay button until
    // the client token has been obtained from your server and has been used to create a
    // Braintree instance.
    
    var braintree: Braintree?
    
    func tappedMyPayButton() {
        // If you haven't already, create and retain a `Braintree` instance with the client token.
        // Typically, you only need to do this once per session.
        //braintree = Braintree(clientToken: CLIENT_TOKEN_FROM_SERVER)
        
        // Create a BTDropInViewController
        let dropInViewController = braintree!.dropInViewControllerWithDelegate(self)
        
        // This is where you might want to customize your Drop-in. (See below.)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(MyViewController.userDidCancelPayment))
        
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
        postNonceToServer(paymentMethod.nonce) // Send payment method nonce to your server
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}*/
