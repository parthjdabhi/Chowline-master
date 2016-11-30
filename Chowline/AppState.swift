//
//  AppState.swift
//  Elenkos
//
//  Created by Dustin Allen on 10/16/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Firebase

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: NSURL?
    var currentUser: FIRDataSnapshot!
}

//Globals
var selectedMarket: Dictionary<String,AnyObject> = [:]
