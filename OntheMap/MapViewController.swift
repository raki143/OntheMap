//
//  MapViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 24/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getStudentLocations(){
        
        UdacityUserAPI.sharedInstance().getStudentLocations(failure: { (error) in
            
            DispatchQueue.main.async(execute: {
                 self.createAlertMessage(title: "Alert", message: "Unable to load students locations.please reload it.")
            })
           
            }) { (result) in
                print("successfully loaded other student locations")
        }
        
    }
    
    @IBAction func logout(){
        UdacityUserAPI.sharedInstance().logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postUserInformation(){
        print("post user Info")
    }
    
    @IBAction func refreshStudentLocations(){
    
        getStudentLocations()
    }
}
