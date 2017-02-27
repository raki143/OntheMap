//
//  constants.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 19/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

// url strings
struct URLString {
    
    static let signUp = "https://www.udacity.com/account/auth#!/signup"
    static let signIn = "https://www.udacity.com/api/session"
    static let logout = "https://www.udacity.com/api/session"
    static let studentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let userInfo = "https://parse.udacity.com/parse/classes/StudentLocation"
}


// apikey and parseAppID values
struct Values{
    
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
}

struct Keys{
    
    static let parseAppID = "X-Parse-Application-Id"
    static let APIKey = "X-Parse-REST-API-Key"
    
}

struct StudentInfoKeys{
    
    // Student Location Creation Key
    static let createdAtKey = "createdAt"
    
    // First Name Key
    static let firstNameKey = "firstName"
    
    // Last Name Key
    static let lastNameKey = "lastName"
    
    // Latitude Key
    static let latitudeKey = "latitude"
    
    // Longitude Key
    static let longitudeKey = "longitude"
    
    // Map String Data Key
    static let mapStringKey = "mapString"
    
    // Student URL Key
    static let mediaURLKey = "mediaURL"
    // Object ID Key
    static let objectIdKey = "objectId"
    
    // Unique Key
    static let uniqueKeyKey = "uniqueKey"
    
    // Updated At Key
    static let updatedAtKey = "updatedAt"
}

