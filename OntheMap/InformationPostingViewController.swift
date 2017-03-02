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
        
        let placeMark = MKPlacemark(placemark: coordinates)
        self.locationMapView.addAnnotation(placeMark)
        
        let region = MKCoordinateRegionMakeWithDistance((placeMark.location?.coordinate)!, 5000.0, 5000.0)
        locationMapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        
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
