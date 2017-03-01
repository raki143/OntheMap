//
//  LocationModel.swift
//  OntheMap
//
//  Created by Rakesh on 3/1/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import MapKit

struct LocationModel {
    
    let latitude : Double
    let longitude : Double
    let mapString : String
    var locationCoordinate2D : CLLocationCoordinate2D{
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
