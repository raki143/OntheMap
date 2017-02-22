//
//  UIViewControllerExtension.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 22/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

extension UIViewController{
    
    
    func createAlertMessage(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async(execute: {
            
            self.present(alert, animated: true, completion: nil)
        })
    }

}

extension UIActivityIndicatorView{
    func hide(){
        DispatchQueue.main.async {
            self.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
