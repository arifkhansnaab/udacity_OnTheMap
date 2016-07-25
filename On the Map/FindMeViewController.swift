//
//  MapViewController.swift
//  On the Map
//
//  Created by Arif Khan on 5/31/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindMeViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtSearchBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var ActInd: UIActivityIndicatorView!
    var localSearchRequest:MKLocalSearchRequest!
    
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    

    
    @IBAction func cancelButtonClick(sender: AnyObject) {
   
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func findOnMapClick(sender: AnyObject) {
    
         ActInd.hidden = false
         ActInd.startAnimating()
        if ( !(!txtSearchBox.text!.isEmpty) ) {
            let alert = UIAlertController(title: "Required Data Alert", message:"Please enter location", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = txtSearchBox.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
        if localSearchResponse == nil {
            let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
        self.pointAnnotation = MKPointAnnotation()
        self.pointAnnotation.title = self.txtSearchBox.text
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            
            let dictParam: NSMutableDictionary? = ["createdAt": dateFormatter.stringFromDate(NSDate()),
                "firstName": LoggedInUserManager.loggedInUser.firstName,
                "lastName": LoggedInUserManager.loggedInUser.lastName,
                "latitude": localSearchResponse!.boundingRegion.center.latitude,
                "longitude": localSearchResponse!.boundingRegion.center.longitude,
                "mapString":"",
                "mediaURL":"",
                "objectId":"",
                "uniqueKey": "",
                "updatedAt":dateFormatter.stringFromDate(NSDate())
            ]
            
            let studentInfo = StudentInformation(dictionary: dictParam!)
            
            self.ActInd.stopAnimating()
            
            StudentLocationSearchManager.studentLocations.append(studentInfo)
            self.performSegueWithIdentifier("ShowMapAfterSearch", sender: self)        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActInd.hidden = true
        txtSearchBox.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        ActInd.hidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FindMeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FindMeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
  func keyboardWillShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if txtSearchBox.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func locationManager(manager: CLLocationManager, status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }
    
}
