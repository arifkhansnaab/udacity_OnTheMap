//
//  ShowMapSearchView.swift
//  On the Map
//
//  Created by Arif Khan on 6/13/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ShowMapSearchViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
 
    @IBAction func cancelButtonClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userEnteredLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        userEnteredLocation.delegate = self
        
        var annotations = [MKPointAnnotation]()
        
        let locationsStruct = StudentLocationSearchManager.studentLocations
        
        for myL in locationsStruct {
            let lat = CLLocationDegrees(myL.latitude)
            let long = CLLocationDegrees(myL.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(myL.firstName) \(myL.lastName)"
            annotation.subtitle = myL.mediaURL
            annotations.append(annotation)
  
            let span = MKCoordinateSpanMake(2, 2)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
        self.mapView.addAnnotations(annotations)
    }

    @IBAction func saveMapInfo(sender: AnyObject) {
     
        var strError : String
        strError = ""
        if ( userEnteredLocation.text?.isEmpty == true) {
            strError = "Unable to post, enter your location"
            strError +=  "\r\n"
        }
        
        //Check that user has entered location
        if (!strError.isEmpty) {
            var finalMessage = "Please enter below fields \r\n"
            finalMessage += strError
            
            self.displayMessage("Required Data Alert", message: finalMessage)
            
            return
        }
        
        var locationsStruct = StudentLocationSearchManager.studentLocations
        
        if (  locationsStruct.count < 1) {
            self.displayMessage("Required Data Alert", message: "No location found in the search result")
            return
        }
        
        locationsStruct[0].uniqueKey = LoggedInUserManager.loggedInUser.userId
        locationsStruct[0].mediaURL = userEnteredLocation.text!
        locationsStruct[0].mapString = userEnteredLocation.text!
        StudentLocationSearchManager.studentLocations.removeAll()
        
        StudentLocationManager.studentLocations.append(locationsStruct[0])
        
        let locationAPIManager = LocationAPIManager()
        
        locationAPIManager.AddUserLocation(locationsStruct[0]) {
            (oResponseObject:ResponseObject) ->() in
            
            if ( oResponseObject.Error.characters.count > 0 ) {
                self.displayMessage("Error", message: oResponseObject.Error)
            } else {
                self.displayMessage("Success", message: "Your location successfully added.")
            }
        }
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
        if ( userEnteredLocation.isFirstResponder()) {
            //view.frame.origin.y = -getKeyboardHeight(notification)+450
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if userEnteredLocation.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                
                let studentLocationURL = NSURL(string: toOpen)
                
                if ( studentLocationURL == nil) {
                    
                    self.displayMessage("Invalid URL", message: toOpen)
                    
                    return
                }
                app.openURL(studentLocationURL!)
            }
            
        }
    }

}


