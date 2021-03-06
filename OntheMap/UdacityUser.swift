//
//  UdacityUser.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 19/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

class UdacityUser : NSObject{
    
    var firstName: String?
    var lastName: String?
    var uniqueKey: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var updatedAt: String?
    var createdAt: String?
    
    static let sharedInstance : UdacityUser = {
        
        let instance = UdacityUser()
        return instance
    }()
    
    func updateUdacityUserDetails(studentDict: [String:AnyObject]) -> Void{
        
        objectId = studentDict[StudentInfoKeys.objectIdKey] as! String?
        updatedAt = studentDict[StudentInfoKeys.updatedAtKey] as! String?
        firstName = studentDict[StudentInfoKeys.firstNameKey] as! String?
        lastName = studentDict[StudentInfoKeys.lastNameKey] as! String?
        uniqueKey = studentDict[StudentInfoKeys.uniqueKeyKey] as! String?
        latitude = studentDict[StudentInfoKeys.latitudeKey] as! Double?
        longitude = studentDict[StudentInfoKeys.longitudeKey] as! Double?
        mapString = studentDict[StudentInfoKeys.mapStringKey] as! String?
        mediaURL = studentDict[StudentInfoKeys.mediaURLKey] as! String?
        createdAt = studentDict[StudentInfoKeys.createdAtKey] as! String?
        
        return
    }
    
}
