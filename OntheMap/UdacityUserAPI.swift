//
//  UdacityUserAPI.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 19/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void

// This class provides method for login, logout and getpublicUserDat
class UdacityUserAPI: NSObject {
    
    // shared session
    var session = URLSession.shared
    
    class func sharedInstance() -> UdacityUserAPI {
        struct Singleton {
            static var sharedInstance = UdacityUserAPI()
        }
        return Singleton.sharedInstance
    }
    
    func signInWithUdacityCredentials(userName:String, password:String,completionHandler handler:RequestCompletionHandler?){
        
        let request = NSMutableURLRequest(url: URL(string: URLString.signIn)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                if let handler = handler{
                    handler(nil,nil,error as NSError?)
                }
                return
            }
            guard let data = data else{
                return
            }
            

            let newData = data.subdata(in: Range(5..<data.count)) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            
            if let handler = handler{
                handler(newData,response,error as NSError?)
            }
        }
        task.resume()
    }
    
    func logout(){
        
        let request = NSMutableURLRequest(url: URL(string: URLString.logout)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func getPublicUserData(completionHandler handler:RequestCompletionHandler?){
      
        let request = NSMutableURLRequest(url: URL(string: URLString.userInfo+UdacityUser.uniqueKey)!)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                if let handler = handler{
                    handler(nil,nil,error as NSError?)
                }
                return
            }
            
            guard let data = data else{
                return
            }
            
            let newData = data.subdata(in: Range(5..<data.count)) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            

            do{
                if let jsonData = try JSONSerialization.jsonObject(with:newData, options:.allowFragments) as? [String:AnyObject]{
                    
                    print("user json is \(jsonData)")
                    
                    if let userDict = jsonData["user"] as? [String:AnyObject]{
                        
                        UdacityUser.firstName = userDict["first_name"] as! String
                        UdacityUser.lastName = userDict["last_name"] as! String
                    }

                }
                

            }catch let error{
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    
    func getStudentLocations(){
        
        let url = URL(string: URLString.studentLocations)
        var urlComponents = URLComponents(string: url!.absoluteString)
        
        urlComponents?.queryItems = [URLQueryItem(name: "limit", value: "100"), URLQueryItem(name: "order", value: "-updatedAt")]
        
        guard let urlWithParam = urlComponents?.url else {
            return
        }

        let request = NSMutableURLRequest(url: urlWithParam)
        request.addValue(Values.parseAppID, forHTTPHeaderField: Keys.parseAppID)
        request.addValue(Values.APIKey, forHTTPHeaderField: Keys.APIKey)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()

    }
}
