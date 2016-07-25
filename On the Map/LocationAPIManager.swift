//
//  LocationAPIManager.swift
//  On the Map
//
//  Created by Arif Khan on 7/2/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationAPIManager {
    
    func DeleteUserSession () {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
        }
        task.resume()
    }
    
    
    func GetExisitingUserLocations( finished:(StudentLocations) -> ()) {
    
        let studentLocations = StudentLocations()
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                studentLocations.Error = (error?.localizedDescription)!
                return
            }
            
            do {
                
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    for (key, value) in json {
                        if ( key as! String  == "error") {
                            studentLocations.Error = value as! String
                        }
                    }
                    
                    if let act1 = json as? NSDictionary {
                        for (key, value) in act1 {
                            if ( key as! String  == "results") {
                                
                                for element in value as! NSMutableArray {
                                 
                                    StudentLocationManager.studentLocations.append(StudentInformation(dictionary: element as! NSDictionary))
                                    studentLocations.Students.append(StudentInformation(dictionary: element as! NSDictionary))
                                    
                                }
                            }
                        }
                    }
                } else {
                    studentLocations.Error = "Error getting user locations"
                }
            } catch let parseError {
                
                // Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                studentLocations.Error = jsonStr as! String
                studentLocations.Error += " "
                studentLocations.Error += String(parseError)
            }
            finished(studentLocations)
        }
        
        task.resume()
    }
    
    func AddUserLocation (student: StudentInformation, finished:(ResponseObject) -> ()) {
        
        let responseObject = ResponseObject()
                       
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(AppConstants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(AppConstants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"\(AppConstants.JsonKey.UniqueKey)\": \"\(student.uniqueKey)\", \"\(AppConstants.JsonKey.FirstName)\": \"\(student.firstName)\", \"\(AppConstants.JsonKey.LastName)\": \"\(student.lastName)\",\"\(AppConstants.JsonKey.MapString)\": \"\(student.mapString)\", \"\(AppConstants.JsonKey.MediaURL)\": \"\(student.mediaURL)\",\"\(AppConstants.JsonKey.Latitude)\": \(student.latitude), \"\(AppConstants.JsonKey.Longitude)\": \(student.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
       
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                
                responseObject.Error = error!.localizedDescription
                finished(responseObject)
                return
            }
            
            do {
                
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                   print(json)
                   
                    if let val = json["error"] {
                        responseObject.Error = val as! String
                    } else {
                        responseObject.Error = ""
                    }
                   
                }
            } catch let parseError {
                let oParseError = parseError as? NSError
                responseObject.Error += oParseError!.localizedDescription
                responseObject.Error += "  "
                responseObject.Error = oParseError.debugDescription
            }
            finished(responseObject)
        }
        task.resume()
        
    }
        
        
}