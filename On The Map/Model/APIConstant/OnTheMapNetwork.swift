//
//  OnTheMapNetwork.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

class OnTheMapNetwork {
    
    
    class func login(email: String,
                     password: String,
                     completeion: @escaping (Bool, String) -> Void) {
        let loginCredentials = LoginCredentials(username: email, password: password)
        let body = Login(udacity: loginCredentials)
        var request = URLRequest(url: OnTheMapClient.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let data = data else {
                    return
                }
                let range = 5 ..< data.count
                let loginResponse = data.subdata(in: range)
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(LoginResponse.self, from: loginResponse)
                    if responseObject.account.registered {
                        completeion(true, "")
                    }else {
                        completeion(false, "")
                    }
                }catch {
                    do {
                        let errorObject = try decoder.decode(LoginErrorResponse.self, from: loginResponse)
                        completeion(false, errorObject.error)
                    } catch {
                        completeion(false, "Failed to connect server")
                    }
                }
            }else {
                    completeion(false, "Failed to connect server")
            }
            
        }
        task.resume()
    }
}


func testJSON(data: Data) {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        print(json)
    }catch  {
        print("JSON parsing failed")
        print(error)
    }
}
