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
    
    
    //MARK: - LOGIN Action
    @IBAction func login(_ sender: AnyObject) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return
        }
        
        UdacityUserAPI.sharedInstance().signInWithUdacityCredentials(userName: email, password: password) { (data, response, error) in
            
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
                }
            }else{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with:data!, options:.allowFragments) as? [String:AnyObject]
                    
                    if let account = jsonData?["account"] as? [String:AnyObject]{
                        
                        UdacityStudent.uniqueKey = account["key"] as! String
                        
                        // present tab bar controller
                        DispatchQueue.main.async {
                            if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarNavigationController"){
                                self.present(tabBarController, animated: true, completion: nil)
                            }
                        }
                        
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
    
    
    @IBAction func signUp(_ sender: AnyObject) {
    }
    
    // Mark: - Alert Methods
    func createAlertMessage(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async(execute: {
            
            self.present(alert, animated: true, completion: nil)
        })
    }
}

