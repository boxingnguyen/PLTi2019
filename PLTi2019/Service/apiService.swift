//
//  ApiService.swift
//  PLTi2019
//
//  Created by Dinh Nhinh on 2/21/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiService: NSObject {
    
    static let shared = ApiService()
    
    func apiPost(path: String, options: [String: String], success : @escaping (_ result: JSON) -> Void, error: @escaping (Error) -> Void) {
        let endPoint = "\(ConstansBook.apiBaseUrl)\(path)"
        
        // add hearder
        let header: HTTPHeaders = [
            "Accept": "application/json"
//            "user-email":   (ConstansBook.session?.email)!
        ]
        
        print(endPoint)
        
        Alamofire.request(endPoint, method: HTTPMethod.post, parameters: options, encoding: URLEncoding.default, headers: header).responseJSON { (respones) in
            
            guard let object = respones.result.value else {
                error(respones.result.error!)
                return
            }
            
            let json = JSON(object)
            
            if respones.response?.statusCode == 400 {
                // Bad request
                
                let errStr = json["error"]["message"].rawValue
                let err = NSError(domain: ConstansBook.apiBaseUrl, code: (json["error"]["code"].rawValue) as? Int ?? 00, userInfo: [NSLocalizedDescriptionKey: errStr])
                error(err)
                
                return
            } else if respones.response?.statusCode == 401 {
                // Unauthenticate
                let err = NSError(domain: ConstansBook.apiBaseUrl, code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                error(err)
                return
            } else if respones.response?.statusCode != 200 {
                // Unexpected error
                let err = NSError(domain: ConstansBook.apiBaseUrl, code: respones.response?.statusCode ?? 00, userInfo: nil)
                error(err)
                return
            }
            
            // Nice
            success(json)
        }
    }
    
    func apiGet(path: String, options: [String: String], success : @escaping(_ result: JSON) -> Void, error: @escaping(Error) -> Void) {
        var endPoint = "\(ConstansBook.apiBaseUrl)\(path)"
        
        // Add paramester
        if options.count > 0 {
            endPoint = endPoint + "?"
            
            for (k, v) in options {
                let escapedString = v.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                endPoint += "\(k)=\(escapedString!)&"
            }
        }
        
        // Add header
        let header: HTTPHeaders = [
            "user-email":   (ConstansBook.session?.email)!,
            ]
        
        print(endPoint)
        Alamofire.request(endPoint, method: .get, parameters: options, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                guard let object = response.result.value else {
                    error(response.result.error!)
                    return
                }
                
                let json = JSON(object)
                
                if response.response?.statusCode == 400 {
                    // Bad request
                    
                    let errStr = json["error"]["message"].rawValue
                    let err = NSError(domain: ConstansBook.apiBaseUrl, code: (json["error"]["code"].rawValue) as? Int ?? 00, userInfo: [NSLocalizedDescriptionKey: errStr])
                    error(err)
                    
                    return
                } else if response.response?.statusCode == 401 {
                    // Unauthenticate
                    let err = NSError(domain: ConstansBook.apiBaseUrl, code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    error(err)
                    return
                } else if response.response?.statusCode != 200 {
                    // Unexpected error
                    let err = NSError(domain: ConstansBook.apiBaseUrl, code: response.response?.statusCode ?? 00, userInfo: nil)
                    error(err)
                    return
                }
                // Nice
                success(json)
        }
        
    }
    
    func apiLogin(email: String, pass: String, success: @escaping(_ result: User) -> Void, error: @escaping(Error) -> Void) {
        let options = [
            "email": email,
            "password": pass
        ]
        apiPost(path: "/api/REST/Users/login.json", options: options, success: { (json) in
            print(json)
//            print(json["User"]["name"])
            
            let user = User(username: "", email: "", password: "")
            user.email = json["User"]["email"].string ?? ""
            user.username = json["User"]["name"].string ?? ""
            success(user)
        }) { (err) in
            error(err)
        }
    }
    
    func apiRegister(user: String, email: String, pass: String, success: @escaping(_ result: User) -> Void, error: @escaping(Error) ->Void) {
        let options = [
            "username": user,
            "email": email,
            "password": pass
        ]
        apiPost(path: "/api/REST/Users/add.json", options: options, success: { (json) in
//            print("json \(json)")
            let user = User(username: "", email: "", password: "")
            user.username = json["User"]["name"].string ?? ""
            user.email = json["User"]["email"].string ?? ""
            success(user)
        }) { (err) in
            error(err)
        }
    }
    
    
}
