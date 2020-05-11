//
//  OnTheMapNetwork.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

class OnTheMapNetwork {
    
    class func getStudentLocation(completeion: @escaping (Bool, String) -> Void) {
        let task = URLSession.shared.dataTask(with: OnTheMapClient.Endpoints.getStudentLocation.url) { (data, response, error) in
            if error == nil {
                guard let data = data else {
                    completeion(false, "Error while trying to user data.")
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(StudentInformation.self, from: data)
                    LocationModel.location = json.results
                    completeion(true, "")
                }catch {
                    completeion(false, error.localizedDescription)
                }
            }else {
                completeion(false, "Failed to connect server")
            }
        }
        task.resume()
    }
    
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
    
    class func logout(completeion: @escaping (Bool, String) -> Void) {
        var request = URLRequest(url: OnTheMapClient.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completeion(false, "Failed to logout")
                return
            }
            let range = 5 ..< data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print("Logout success")
            print(String(data: newData!, encoding: .utf8)!)
            completeion(true, "")
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
