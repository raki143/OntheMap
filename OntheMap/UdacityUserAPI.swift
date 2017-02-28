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
    
    func logout(result:@escaping (_ success:Bool) -> Void){
        
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
                result(false)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            result(true)
        }
        task.resume()
    }
    
    func getPublicUserData(completionHandler handler:RequestCompletionHandler?){
        
        do{
            
            let url = URL(string: URLString.userInfo)
            var urlComponents = URLComponents(string: url!.absoluteString)
            let query = ["\(StudentInfoKeys.uniqueKeyKey)":"\(UdacityUser.sharedInstance.uniqueKey!)"]
            let dataValue = try JSONSerialization.data(withJSONObject: query, options: JSONSerialization.WritingOptions())
            let qValue = NSString(data: dataValue, encoding: String.Encoding.utf8.rawValue)! as String
            
            urlComponents?.queryItems = [URLQueryItem(name: "where", value:"\(qValue)")]
            
            guard let urlWithParam = urlComponents?.url else {
                return
            }
            print("userInfo url is \(urlWithParam)")
            
            let request = NSMutableURLRequest(url: urlWithParam)
            request.addValue(Values.parseAppID, forHTTPHeaderField: Keys.parseAppID)
            request.addValue(Values.APIKey, forHTTPHeaderField: Keys.APIKey)
            
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
                
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                
                
                do{
                    if let jsonData = try JSONSerialization.jsonObject(with:data, options:.allowFragments) as? [String:AnyObject]{
                        
                        print("user json is \(jsonData)")
                        
                        if let userDict = jsonData["results"] as? [String:AnyObject], !userDict.isEmpty {
                            
                            let _ = UdacityUser(studentDict: userDict)
                            
                        }
                        
                    }
                    
                    
                }catch let error{
                    print(error)
                }
            }
            
            task.resume()
            
        }catch let error{
            print(error)
        }
    }
    
    func getStudentLocations(failure : @escaping (_ errorOccured : Error) -> Void, success: @escaping (_ result:Bool) -> Void){
        
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
            
            guard (error == nil) else {
                // propagate this error using notification
                failure(onTheMapErrors.ErrorInGetStudentLocations)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                // propagate this error using notification
                failure(onTheMapErrors.ErrorInGetStudentLocations)
                return
            }
            
            guard let data = data else{
                // propagate this error using notification
                failure(onTheMapErrors.ErrorInGetStudentLocations)
                return
            }
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            do{
                if let jsonData = try  JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]{
                    if let studentArray = jsonData["results"] as? [[String:AnyObject]]{
                        StudentInfoModel.getStudentList(fromStudents: studentArray)
                        success(true)
                    }
                }
                
            }catch let error{
                print(error)
            }
        }
        task.resume()
        
    }
}
