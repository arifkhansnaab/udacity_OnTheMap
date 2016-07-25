//
//  AuthenticationManager.swift
//  On the Map
//
//  Created by Arif Khan on 6/26/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

class AuthenticationManager {
    
    func HydrateUser(userId: String, finished:(LoggedInUser) -> ()) {
        
        let oUser = LoggedInUser()
        var url = "https://www.udacity.com/api/users/"
        url += userId
        
        let request = NSMutableURLRequest(URL: NSURL(string: url )!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                
                oUser.loginError = error!.localizedDescription
                return
            }
            
            do {
                
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length-5))
                if let json = try NSJSONSerialization.JSONObjectWithData(newData, options: []) as? NSDictionary {
                    
                    for (key, value) in json {
                        if ( key as! String  == "error") {
                            oUser.loginError = (value as? String)!
                        }
                    }
                    
                    if let act1 = json["user"] as? NSDictionary {
                        
                        oUser.userId = userId
                        oUser.firstName = act1["first_name"] as! String
                        oUser.lastName = act1["last_name"] as! String
                        
                    }
                }
                else {
                    _ = NSString(data: newData, encoding: NSUTF8StringEncoding)
                }
                
            } catch let parseError {
                oUser.loginError = (parseError as? String)!
            }
            finished(oUser)
        }
        
        task.resume()
        
    }
    func Authenticate (userId: String, password: String, finished:(LoggedInUser) -> ()) {
        
        let oUser = LoggedInUser()
        
        var strBody = "{\"udacity\": {\"username\": \""
        strBody += userId
        strBody += "\""
        strBody += ", \"password\":\""
        strBody += password
        strBody += "\"}}"
        
        var registeredUser: Bool
        registeredUser = false
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = strBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            guard data != nil else {
                
                oUser.loginError = error!.localizedDescription
                finished(oUser)
                return
            }
            
            do {
                
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length-5))
                if let json = try NSJSONSerialization.JSONObjectWithData(newData, options: []) as? NSDictionary {
                    
                    
                    for (key, value) in json {
                        if ( key as! String  == "error") {
                            oUser.loginError = (value as? String)!
                        }
                    }
                    
                    if let act1 = json["account"] as? NSDictionary {

                        for (key, value) in act1 {
                            
                            if ( key as! String  == "registered") {
                                registeredUser = value as! Bool
                            }
                            
                            if ( key as! String  == "key") {
                                oUser.userId = value as! String
                            }
                        }
                    }
                }
                else {
                    let jsonStr = NSString(data: newData, encoding: NSUTF8StringEncoding)
                    oUser.loginError = String(jsonStr)
                }
                
            } catch let parseError {
                oUser.loginError = (parseError as? String)!
            }
            finished(oUser)
        }
        
        task.resume()
    }
}