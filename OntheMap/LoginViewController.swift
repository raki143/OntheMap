//
//  LoginViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 12/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var selectedTextField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyBoardNotificatin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyBoardNotification()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - KeyBoard Resigning and Notification
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func keyBoardWillShow(_ notification:Notification){
        
        if passwordTextField.isFirstResponder && view.frame.origin.y == 0{
            view.frame.origin.y = getKeyBoardHeight(notification) * -0.5
        }
    }
    
    func getKeyBoardHeight(_ notification:Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func keyBoardWillHide(_ notification:Notification){
        if selectedTextField.isFirstResponder{
            view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyBoardNotificatin(){
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyBoardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: - Login Action
    @IBAction func login(_ sender: AnyObject) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return
        }
        
        if email.isEmpty || password.isEmpty{
            self.createAlertMessage(title: "Alert", message: "Please enter valid credentials.")
            return
        }
        let activityIndicator = showActivityIndicator()
        UdacityUserAPI.sharedInstance().signInWithUdacityCredentials(userName: email, password: password) { (data, response, error) in
            
            DispatchQueue.main.async(execute: {
                activityIndicator.hide()
            })
            
            
            if let response = response as? HTTPURLResponse{
                if response.statusCode < 200 || response.statusCode > 300{
                    self.createAlertMessage(title: "Alert", message: "Incorrect Username or Password. Please enter correct credentials.")
                    return
                }
            }
            
            if let error = error{
                if error.code == NSURLErrorNotConnectedToInternet{
                    self.createAlertMessage(title: "Alert", message: "Seems like you don't have an internet connection")
                    return
                }else{
                    self.createAlertMessage(title: "Alert", message: "sorry we are unable to serve your request.Please try again.")
                }
            }else{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with:data!, options:.allowFragments) as? [String:AnyObject]
                    
                    if let account = jsonData?["account"] as? [String:AnyObject]{
                        
                        UdacityUser.sharedInstance.uniqueKey = account["key"] as? String
                       self.getUserData()
                        // present tab bar controller
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "loginToTabView", sender: self)
                        })
                        
                        
                    }else{
                        
                        self.createAlertMessage(title: "Alert", message: "Incorrect Username or Password. Please enter correct credentials.")
                        return
                        
                    }
                }catch{
                    print("the json data could not be obtained")
                    
                }
                
            }
            
        }
    }
    
   //MARK: - Signup Action
    @IBAction func signUp(_ sender: AnyObject) {
        _ = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        UIApplication.shared.openURL(URL(string: URLString.signUp)!)
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
    
    func getUserData(){
        
        UdacityUserAPI.sharedInstance().getPublicUserData { (data, response, error) in
            
            if let error = error{
                self.createAlertMessage(title: "Error", message: error.description)
            }
            
        }
        
    }

}



