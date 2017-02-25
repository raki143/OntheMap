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
        
        let activityIndicator = showActivityIndicator()
        UdacityUserAPI.sharedInstance().getStudentLocations(failure: { (error) in
            
            DispatchQueue.main.async(execute: {
                activityIndicator.hide()
                 self.createAlertMessage(title: "Alert", message: "Unable to load students locations.please reload it.")
            })
           
            }) { (result) in
                print("successfully loaded other student locations")
                DispatchQueue.main.async(execute: {
                    activityIndicator.hide()
                })
        }
        
    }
    
    @IBAction func logout(){
        
        let activityIndicator = showActivityIndicator()
        UdacityUserAPI.sharedInstance().logout { (result) in
            
            DispatchQueue.main.async(execute: {
                activityIndicator.hide()
            })
            
            if result{
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            }else{
                self.createAlertMessage(title: "Alert", message: "Error in logout. Please try again later.")
            }
        }
    }
    
    @IBAction func postUserInformation(){
        print("post user Info")
    }
    
    @IBAction func refreshStudentLocations(){
    
        getStudentLocations()
    }
    
    //MARK: - Activity Indicator Method
    func showActivityIndicator() -> UIActivityIndicatorView{
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        DispatchQueue.main.async {
            activityIndicator.center = self.view.center
            activityIndicator.color = UIColor.black
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        return activityIndicator
    }
}
