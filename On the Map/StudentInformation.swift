//
//  Location.swift
//  On the Map
//
//  Created by Arif Khan on 6/12/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct StudentInformation {
    var createdAt : NSDate
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mapString : String
    var mediaURL : String
    var objectId : String
    var uniqueKey : String
    var updatedAt : NSDate

    init (dictionary: NSDictionary) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        
        self.createdAt = dateFormatter.dateFromString(dictionary["createdAt"]! as! String)!
        self.firstName = dictionary["firstName"]! as! String
        self.lastName = dictionary["lastName"]! as! String
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.mapString = dictionary["mapString"]! as! String
        self.mediaURL = dictionary["mediaURL"]! as! String
        self.objectId = dictionary["objectId"]! as! String
        self.uniqueKey = dictionary["uniqueKey"]! as! String
        self.updatedAt = dateFormatter.dateFromString(dictionary["updatedAt"]! as! String)!
    }
    

}
