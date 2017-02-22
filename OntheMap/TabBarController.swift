//
//  TabBarController.swift
//  OntheMap
//
//  Created by Rakesh on 2/22/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityUserAPI.sharedInstance().getPublicUserData { (data, response, error) in
            
            if let error = error{
                print(error.description)
            }
            
        }
        
    }

    
    

    

}
