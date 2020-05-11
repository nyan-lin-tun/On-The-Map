//
//  OnTheMapClient.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var userId = ""
    }
    
    struct UserInfo {
        static var firstName = ""
        static var lastName = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getUserInfo
        case signUp
        case logout
        
        case getStudentLocation
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            
            case .login:
                return Endpoints.base + "/session"
                
            case .getUserInfo:
                return Endpoints.base + "/users/\(Auth.userId)"
            
            case .signUp:
                return "https://auth.udacity.com/sign-up"
                
            case .logout:
                return Endpoints.base + "/session"
                
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
            
    }
    
}
