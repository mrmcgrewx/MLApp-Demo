//
//  UserInfo.swift
//  GeoScale
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public struct UserInfo: Serialization {
    let username: String
    let token: String
    
    init(_ json: [String:Any]) throws {
        self.username = try UserInfo.value("username", from: json)
        self.token = try UserInfo.value("token", from: json)
    }
    
}
