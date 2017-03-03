//
//  MapViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 24/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
                    self.showPins()
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
        if let _ = UdacityUser.sharedInstance.objectId {
            
            let alert = UIAlertController(title:"Alert ", message: AlertMessage.overWriteLocation, preferredStyle: .alert)
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (alert: UIAlertAction!) in
                
                self.performSegue(withIdentifier: "informationPostingVC", sender: nil)
            })
            
            let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
            
            alert.addAction(overwriteAction)
            alert.addAction(cancel)
            
            DispatchQueue.main.async(execute: {
                
                self.present(alert, animated: true, completion: nil)
            })
            
        }else{
            performSegue(withIdentifier: "informationPostingVC", sender: nil)
        }
    }
    
    @IBAction func refreshStudentLocations(){
    
        getStudentLocations()
    }
    
    func showPins(){
        
        let students = StudentInfoModel.students
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        DispatchQueue.main.async { 
            for annotation in self.mapView.annotations{
                self.mapView.removeAnnotation(annotation)
            }
        }
        
        for student in students {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            if let latitude = student.latitude, let longitude = student.longitude{
                
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = student.firstName ?? ""
                let last = student.lastName ?? ""
                let mediaURL = student.mediaURL ?? ""
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
        }
        
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async { 
            self.mapView.addAnnotations(annotations)
        }
        
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
    
    //MARK: - MKMapViewDelegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
                        
            guard let availableURL = view.annotation?.subtitle, let url = URL(string: availableURL!) , UIApplication.shared.openURL(url) == true else{
                
                self.createAlertMessage(title: "Invalid URL", message: "Unable to open provided link.")
                return
            }

        }
    }
}
