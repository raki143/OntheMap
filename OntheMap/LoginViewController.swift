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
        
    }
    

    @IBAction func signUp(_ sender: AnyObject) {
    }
}

