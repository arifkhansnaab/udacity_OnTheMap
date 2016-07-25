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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Populate existing users
        let oLocationAPIManager = LocationAPIManager()
        oLocationAPIManager.GetExisitingUserLocations() {
            (oStudentLocations:StudentLocations) ->() in
            
            if ( oStudentLocations.Error.characters.count > 0 ) {
                self.displayMessage("Login error", message: oStudentLocations.Error)
               
            }
            self.AddStudentLocationToMap(oStudentLocations.Students)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        mapView.reloadInputViews()
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
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
    
    func AddStudentLocationToMap(studendsInformation:[StudentInformation]) {
            for student in studendsInformation  {
                
                var annotations = [MKPointAnnotation]()
                let lat = CLLocationDegrees(student.latitude)
                let long = CLLocationDegrees(student.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(student.firstName) \(student.lastName)"
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
                self.mapView.addAnnotations(annotations)
        }
    }
    
    @IBAction func logoutUser(sender: AnyObject) {
        
        let locationAPIManager = LocationAPIManager()
        locationAPIManager.DeleteUserSession()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
