//
//  MapViewController.swift
//  Chowline
//
//  Created by Dustin Allen on 11/13/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

var selectedSuperMarket = [String]()
var selectedSuperMarketName = ""

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var ref:FIRDatabaseReference!
    var user: FIRUser!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var selectedLocation: CLLocation?
    var getCurrentLocation: Bool = true
    
    var venueName:String = ""
    var pointPlace = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        ref.child("markets").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            for child in snapshot.children {
                
                //var placeDict = Dictionary<String,AnyObject>()
                //let childDict = child.valueInExportFormat() as! NSDictionary
                //print(childDict)
                print(child)
                
                let snap = child as! FIRDataSnapshot
                if userID != snap.key {

                    selectedSuperMarket = [snap.key as String!]
                    /*for x in selectedSuperMarket {
                        //print(x)
                    }
                    //print(selectedSuperMarket)*/
                    self.venueName = snap.value!["userName"] as! String!
                    let lat = snap.value!["lat"] as! Double!
                    let long = snap.value!["long"] as! Double!
                    
                    let coordinatePoints = CLLocationCoordinate2DMake(lat, long)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinatePoints
                    dropPin.title = self.venueName
                    self.mapView.addAnnotations([dropPin])
                }
            }
        })
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.action(_:)))
        uilpgr.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(uilpgr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            if self.mapView.selectedAnnotations.count > 0 {
                
                if let ann = self.mapView.selectedAnnotations[0] as? MKAnnotation {
                    
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    
                    ref.child("markets").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                        for child in snapshot.children {

                            //print(child)
                            
                            let snap = child as! FIRDataSnapshot
                            if userID != snap.key {
                                if snap.value!["userName"] as! String! == ann.title! as String! {
                                    selectedSuperMarketName = snap.key as String!
                                    print(selectedSuperMarketName)
                                    self.searchingTimer()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func searchingTimer() {
        CommonUtils.sharedUtils.showProgress(self.view, label: "Loading Supermarket...")
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(MapViewController.segueInformation), userInfo: nil, repeats: false)
    }
    
    func segueInformation() {
        CommonUtils.sharedUtils.hideProgress()
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("ViewMarketViewController") as! ViewMarketViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
}
