//
//  StudentManager.swift
//  On the Map
//
//  Created by Arif Khan on 6/26/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation

class StudentLocationManager {
    static let sharedInstance = StudentLocationManager()
    static var studentLocations = [StudentInformation]()
    private init() {}
}