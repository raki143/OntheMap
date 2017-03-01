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
    static let publicUserData = "https://www.udacity.com/api/users/"

}


// apikey and parseAppID values
struct Values{
    
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let contentType = "application/json"
}

struct Keys{
    
    static let parseAppID = "X-Parse-Application-Id"
    static let APIKey = "X-Parse-REST-API-Key"
    static let contentType = "Content-Type"
    static let accept = "Accept"
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

// Json response keys
struct JSONResponseKeys {
    static let error = "error"
    static let results = "results"
    static let objectID = "objectId"
    static let updatedAt = "updatedAt"
    static let uniqueKey = "uniqueKey"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let mediaURL = "mediaURL"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let mapString = "mapString"
    static let createdAt = "createdAt"
}

