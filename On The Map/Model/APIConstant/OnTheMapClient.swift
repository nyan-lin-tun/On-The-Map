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
    
    class func doPOSTRequest<RequestType: Encodable, ResponseType: Decodable> (url: URL, body: RequestType ,responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                /*
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
 */
            }
        }
        task.resume()
    }
}
