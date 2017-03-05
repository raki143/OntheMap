//
//  InformationPostingViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 02/03/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController,UITextViewDelegate {

    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var activityIndicator : UIActivityIndicatorView?
    var coordinatePoint : CLPlacemark?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        linkTextView.delegate = self
        locationTextView.delegate = self
        linkTextView.returnKeyType = .done
        locationTextView.returnKeyType = .done
        clearOutKeyboard()
        submitButton.isHidden = true
        linkTextView.alpha = 0
        
    }
    
    @IBAction func findOnTheMapAction(_ sender: Any) {
        
        
        let locationText = locationTextView.text!
        self.activityIndicator = showActivityIndicator()
        CLGeocoder().geocodeAddressString(locationText) { (placemark, error) in
            
            self.activityIndicator?.hide()
            
            if error != nil{
                self.createAlertMessage(title: "Alert", message: "Failed to geocode the given location.Please try another address")
            }else if placemark!.count > 0{
                let coordinates = placemark![0] as CLPlacemark
                self.presentLocationOnTheMap(usingCoordinates: coordinates)
            }else{
                self.createAlertMessage(title: "Alert", message: "No Placemarks returned for the given location.")
            }
        }
        
        
    }
    
    func presentLocationOnTheMap(usingCoordinates coordinates : CLPlacemark ){
        
        UIView.animate(withDuration: 0.5) {
            self.titleLabel.isHidden = true
            self.linkTextView.alpha = 1.0
            self.locationTextView.alpha = 0
            self.findOnMapButton.isHidden = true
            self.submitButton.isHidden = false
            
        }
        
        self.coordinatePoint = coordinates
        let placeMark = MKPlacemark(placemark: coordinates)
        self.locationMapView.addAnnotation(placeMark)
        let region = MKCoordinateRegionMakeWithDistance((placeMark.location?.coordinate)!, 5000.0, 5000.0)
        locationMapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        let activityIndicator = showActivityIndicator()
        let mapString = locationTextView.text!
        let latitude = (self.coordinatePoint?.location?.coordinate.latitude)!
        let longitude = (self.coordinatePoint?.location?.coordinate.longitude)!
        
        let location = LocationModel(latitude: latitude, longitude: longitude, mapString: mapString)
        let mediaURL = linkTextView.text!
        
        
        if let _ = UdacityUser.sharedInstance.objectId{
            
            // update user location
           UdacityUserAPI.sharedInstance().updatestudentLocationWith(location: location, withMediaURL: mediaURL, usingUdacityUserDetails: UdacityUser.sharedInstance, withHandler: { (result, error) in
            
            activityIndicator.hide()
            
                if result{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    
                    switch error{
                    case onTheMapErrors.noInternetConnection:
                        self.createAlertMessage(title: "Alert", message: "Seems like you don't have an internet connection")
                        break
                    default:
                        self.createAlertMessage(title: "Alert", message: "Sorry, We are unable to update your location. Please try again later.")
                        break
                    }
                }
            })
            
      }else{
            // post user location
            
            UdacityUserAPI.sharedInstance().postStudentLocationWith(location: location, withMediaURL: mediaURL, usingUdacityUserDetails: UdacityUser.sharedInstance, withHandler: { (result, error) in
                
                activityIndicator.hide()
                
                if result{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    
                    switch error{
                    case onTheMapErrors.noInternetConnection:
                        self.createAlertMessage(title: "Alert", message: "Seems like you don't have an internet connection")
                        break
                    default:
                        self.createAlertMessage(title: "Alert", message: "Sorry, We are unable to post your location. Please try again later.")
                        break
                    }
                    
                }
            })
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TextViewDelegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            dismissKeyboard()
            return false
        }
        return true
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
