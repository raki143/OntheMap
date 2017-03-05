//
//  onTheMapErrors.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 25/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

enum onTheMapErrors : Error {
   
    case noError // This is used because nil is not compatible with Error
    case noInternetConnection
    case errorInGetStudentLocations
    case errorInGetUserPublicData
    case errorInGetUserLocationData
    case errorInUpdateStudentLocation
    case errorInPostingStudentLocation
}
