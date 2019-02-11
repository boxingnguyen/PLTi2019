//
//  Api.swift
//  PLTi2019
//
//  Created by Quyen Anh on 1/30/19.
//  Copyright © 2019 Quyen Anh. All rights reserved.
//

import Foundation

class Api: NSObject {
    static let shared = Api()
    
    func login(username: String, password: String, success : @escaping (_ result: Any) -> Void, error: @escaping (Error) -> Void) {
        let string = "deptrai"
        success(string)
    }
}
