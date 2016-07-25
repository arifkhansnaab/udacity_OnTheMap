//
//  MapListViewController.swift
//  On the Map
//
//  Created by Arif Khan on 6/23/16.
//  Copyright © 2016 Snnab. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBAction func logoutUser(sender: AnyObject) {
        let locationAPIManager = LocationAPIManager()
        locationAPIManager.DeleteUserSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView!.reloadData()
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationManager.studentLocations.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var strName = StudentLocationManager.studentLocations[indexPath.row].firstName
        strName += " "
        strName += StudentLocationManager.studentLocations[indexPath.row].lastName
        strName += "\n"
        strName += StudentLocationManager.studentLocations[indexPath.row].mediaURL
        cell!.textLabel?.text = strName
        
        cell!.textLabel?.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell!.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let studentInformation = StudentLocationManager.studentLocations[row]
        print(studentInformation.lastName)
        
        let app = UIApplication.sharedApplication()
       
            let studentLocationURL = NSURL(string: studentInformation.mediaURL)
            
            if ( studentLocationURL == nil) {
                self.displayMessage("Invalid URL", message: studentInformation.mediaURL)
                return
            }
            app.openURL(studentLocationURL!)
        
    }
    
}




