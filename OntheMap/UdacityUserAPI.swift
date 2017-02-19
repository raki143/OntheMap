//
//  UdacityUserAPI.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 19/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void

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
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
    
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                if let completion = handler{
                    completion(nil,nil,error as NSError?)
                }
                return
            }
            guard let data = data else{
                return
            }
            

            let newData = data.subdata(in: Range(5..<data.count)) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            
            if let completion = handler{
                completion(newData,response,error as NSError?)
            }
        }
        task.resume()
    }
    
}
