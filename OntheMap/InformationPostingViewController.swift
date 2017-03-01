//
//  InformationPostingViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 02/03/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController,UITextViewDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextView.delegate = self
        locationTextView.delegate = self
        
        
    }

    
}
