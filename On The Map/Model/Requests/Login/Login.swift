//
//  Login.swift
//  On The Map
//
//  Created by Nyan Lin Tun on 11/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation

struct Login: Codable {
    
    let udacity: LoginCredentials
    
    enum CodingKeys: String, CodingKey {
        case udacity = "udacity"
    }
    
}
