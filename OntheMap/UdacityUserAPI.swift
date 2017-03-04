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
    
    func getUserLocationData(success: @escaping (_ result:Bool, _ error : Error) -> Void){
        
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
                
                
                guard (error == nil) else{
                    success(false,onTheMapErrors.errorInGetUserLocationData)
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    success(false, onTheMapErrors.errorInGetUserLocationData)
                    return
                }
                
                guard let data = data else{
                    success(false, onTheMapErrors.errorInGetUserLocationData)
                    return
                }
                
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                
                
                do{
                    if let jsonData = try JSONSerialization.jsonObject(with:data, options:.allowFragments) as? [String:AnyObject]{
                        
                        print("user json is \(jsonData)")
                        
                        if let userInfoArray = jsonData["results"] as? [[String:AnyObject]], userInfoArray.count > 0 {
                            
                            print("userInfoArray is \(userInfoArray)")
                            
                            let count = userInfoArray.count
                            let userDict = userInfoArray[count - 1]
                            
                            print("userInfo is \(userDict)")
                            let udacityUser = UdacityUser.sharedInstance
                            udacityUser.updateUdacityUserDetails(studentDict: userDict)
                            print("shared Instance objectId is \(UdacityUser.sharedInstance.objectId)")
                            print("objectId is \(udacityUser.objectId)")
                            
                            success(true, onTheMapErrors.noError)
                            
                        }else{
                            
                            self.getUserPublicData(success: { (result, err) in
                                
                                // if result is false implies unable to fetch user details.
                                success(result,err)
                            })
                        }
                        
                    }
                    
                    
                }catch {
                    success(false, onTheMapErrors.errorInGetUserLocationData)
                    return
                }
            }
            
            task.resume()
            
        }catch {
            success(false, onTheMapErrors.errorInGetUserLocationData)
            return
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
                failure(onTheMapErrors.errorInGetStudentLocations)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                // propagate this error using notification
                failure(onTheMapErrors.errorInGetStudentLocations)
                return
            }
            
            guard let data = data else{
                // propagate this error using notification
                failure(onTheMapErrors.errorInGetStudentLocations)
                return
            }
            
            print("************ getStudentLocations ******************")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            do{
                if let jsonData = try  JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]{
                    if let studentArray = jsonData[JSONResponseKeys.results] as? [[String:AnyObject]]{
                        StudentInfoModel.getStudentList(fromStudents: studentArray)
                        success(true)
                    }
                }
                
            }catch let error{
                print(error)
                failure(onTheMapErrors.errorInGetStudentLocations)
            }
        }
        task.resume()
        
    }
    
    func getUserPublicData(success: @escaping (_ result:Bool, _ error : Error) -> Void){
        
        let url = URL(string: URLString.publicUserData+UdacityUser.sharedInstance.uniqueKey!)
        let request = NSMutableURLRequest(url: url!)
        request.addValue(Values.parseAppID, forHTTPHeaderField: Keys.parseAppID)
        request.addValue(Values.APIKey, forHTTPHeaderField: Keys.APIKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else{
                success(false,onTheMapErrors.errorInGetUserPublicData)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                success(false, onTheMapErrors.errorInGetUserPublicData)
                return
            }
            
            guard let data = data else{
                success(false, onTheMapErrors.errorInGetUserPublicData)
                return
            }
            
            let newData = data.subdata(in: Range(5..<data.count))
            
            print("************** getUserPublicData ********************")
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            do{
                if let jsonData = try  JSONSerialization.jsonObject(with: newData, options:.allowFragments) as? [String:AnyObject]{
                    if let userDetails = jsonData["user"] as? [String:AnyObject], let firstName = userDetails["first_name"], let lastName = userDetails["last_name"]{
                        
                        UdacityUser.sharedInstance.firstName = firstName as? String
                        UdacityUser.sharedInstance.lastName = lastName as? String
                        success(true, onTheMapErrors.noError)
                        
                    }else{
                        success(false, onTheMapErrors.errorInGetUserPublicData)
                        
                    }
                }
                
            }catch let error{
                print(error)
                success(false, onTheMapErrors.errorInGetUserPublicData)
                
            }
        }
        
        task.resume()
    }
    
    func updatestudentLocationWith(location:LocationModel,withMediaURL mediaURL:String, usingUdacityUserDetails user:UdacityUser, withHandler responseClosure: @escaping (_ success:Bool, _ error:Error) -> Void){
        
   
        let baseURL = URL(string: URLString.userInfo)
        let url = URL(string: UdacityUser.sharedInstance.objectId!, relativeTo: baseURL)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Values.parseAppID, forHTTPHeaderField: Keys.parseAppID)
        request.addValue(Values.APIKey, forHTTPHeaderField: Keys.APIKey)
        request.addValue(Values.contentType, forHTTPHeaderField: Keys.contentType)
        
        let requestBody : [String : AnyObject] =   [StudentInfoKeys.uniqueKeyKey: user.uniqueKey! as AnyObject,
                                                    StudentInfoKeys.firstNameKey : user.firstName! as AnyObject,
                                                    StudentInfoKeys.lastNameKey : user.lastName! as AnyObject,
                                                    StudentInfoKeys.mapStringKey: location.mapString as AnyObject,
                                                    StudentInfoKeys.mediaURLKey: mediaURL as AnyObject,
                                                    StudentInfoKeys.latitudeKey: location.latitude as AnyObject,
                                                    StudentInfoKeys.longitudeKey: location.longitude as AnyObject]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody, options: JSONSerialization.WritingOptions())
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else{
                responseClosure(false,onTheMapErrors.errorInUpdateStudentLocation)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                responseClosure(false,onTheMapErrors.errorInUpdateStudentLocation)
                return
            }
            
            guard let data = data else{
                responseClosure(false,onTheMapErrors.errorInUpdateStudentLocation)
                return
            }
            
            do{
                if let jsonData = try  JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject], let updatedAt = jsonData[JSONResponseKeys.updatedAt] as? String{
                    
                    user.updatedAt = updatedAt
                    user.latitude = location.latitude
                    user.longitude = location.longitude
                    user.mapString = location.mapString
                    user.mediaURL = mediaURL
                    responseClosure(true,onTheMapErrors.noError)
                }
                
                responseClosure(false,onTheMapErrors.errorInUpdateStudentLocation)
                
            }catch{
                responseClosure(false,onTheMapErrors.errorInUpdateStudentLocation)
                return
            }
            
            
        }
        
        task.resume()
        
    }
    
    func postStudentLocationWith(location:LocationModel,withMediaURL mediaURL:String, usingUdacityUserDetails user:UdacityUser, withHandler responseClosure: @escaping (_ success:Bool, _ error:Error) -> Void){
        
        let url = URL(string: URLString.userInfo)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Values.parseAppID, forHTTPHeaderField: Keys.parseAppID)
        request.addValue(Values.APIKey, forHTTPHeaderField: Keys.APIKey)
        request.addValue(Values.contentType, forHTTPHeaderField: Keys.contentType)
        

        let requestBody : [String : AnyObject] =   [StudentInfoKeys.uniqueKeyKey: user.uniqueKey! as AnyObject,
                                                    StudentInfoKeys.firstNameKey : user.firstName! as AnyObject,
                                                    StudentInfoKeys.lastNameKey : user.lastName! as AnyObject,
                                                    StudentInfoKeys.mapStringKey: location.mapString as AnyObject,
                                                    StudentInfoKeys.mediaURLKey: mediaURL as AnyObject,
                                                    StudentInfoKeys.latitudeKey: location.latitude as AnyObject,
                                                    StudentInfoKeys.longitudeKey: location.longitude as AnyObject]
        
       request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody, options: JSONSerialization.WritingOptions())
        

        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else{
                responseClosure(false,onTheMapErrors.errorInPostingStudentLocation)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                responseClosure(false,onTheMapErrors.errorInPostingStudentLocation)
                return
            }
            
            guard let data = data else{
                responseClosure(false,onTheMapErrors.errorInPostingStudentLocation)
                return
            }
            
            do{
                if let jsonData = try  JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject], let objectID = jsonData[JSONResponseKeys.objectID] as? String,let createdAt = jsonData[JSONResponseKeys.createdAt] as? String{
                    
                    print("objectID is \(objectID)")
                    user.createdAt = createdAt
                    user.updatedAt = createdAt
                    user.objectId = objectID
                    user.latitude = location.latitude
                    user.longitude = location.longitude
                    user.mapString = location.mapString
                    user.mediaURL = mediaURL
                    responseClosure(true,onTheMapErrors.noError)
                }else{
                    
                    responseClosure(false,onTheMapErrors.errorInPostingStudentLocation)
                }
                
                
                
            }catch{
                responseClosure(false,onTheMapErrors.errorInPostingStudentLocation)
                return
            }
            
            
        }
        
        task.resume()
        
    }
    
    
    
}
