//
//  UserAuthInfo.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

// Stores the required header in each reques in order to authenticate user with CardMine API.
struct UserAuthInfo {
    // Mark: - Properties
    static let tokenType: String = "Bearer"
    var accessToken: String
    var client: String
    var expiry: String
    var uid: String
}
