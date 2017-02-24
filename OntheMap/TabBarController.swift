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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentLocations))
        let pinButton = UIBarButtonItem(image: UIImage(named:"pin"), style: .plain, target: self, action: #selector(postUserInformation))
        navigationItem.rightBarButtonItems = [pinButton,reloadButton]
        
        getUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get other students data
        getStudentLocations()
    }
    
    func getUserData(){
        
        UdacityUserAPI.sharedInstance().getPublicUserData { (data, response, error) in
            
            if let error = error{
                self.createAlertMessage(title: "Error", message: error.description)
            }
            
        }

    }

    func getStudentLocations(){
        
        UdacityUserAPI.sharedInstance().getStudentLocations()
        
    }
    
    func logout(){
        UdacityUserAPI.sharedInstance().logout()
        dismiss(animated: true, completion: nil)
    }
    
    func postUserInformation(){
        print("post user Info")
    }

}
