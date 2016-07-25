//
//  MessageViewController.swift
//  On the Map
//
//  Created by Arif Khan on 7/3/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import MapKit



extension UIViewController {
    func displayMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
               
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}