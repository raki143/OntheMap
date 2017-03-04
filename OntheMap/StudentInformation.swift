//
//  StudentInformation.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 23/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var createdAt : String?
    var objectId : String?
    var updatedAt : String?
    var firstName : String?
    var lastName : String?
    var uniqueKey : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    
    init(studentDict : [String : AnyObject]){
        
        createdAt = studentDict[StudentInfoKeys.createdAtKey] as? String
        objectId = studentDict[StudentInfoKeys.objectIdKey] as? String
        updatedAt = studentDict[StudentInfoKeys.updatedAtKey] as? String
        firstName = studentDict[StudentInfoKeys.firstNameKey] as? String
        lastName = studentDict[StudentInfoKeys.lastNameKey] as? String
        uniqueKey = studentDict[StudentInfoKeys.uniqueKeyKey] as? String
        latitude = studentDict[StudentInfoKeys.latitudeKey] as? Double
        longitude = studentDict[StudentInfoKeys.longitudeKey] as? Double
        mapString = studentDict[StudentInfoKeys.mapStringKey] as? String
        mediaURL = studentDict[StudentInfoKeys.mediaURLKey] as? String
        
        
    }
    
    
}



