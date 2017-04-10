//
//  UserAuthInfo.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation


// Stores the required headers in each request,
// in order to authenticate a user with CardMine API.
struct UserAuthInfo {
    
    // Mark: - Properties

    let tokenType: String = "Bearer"
    var accessToken: String
    var client: String
    var expiry: String
    var uid: String
    
    // Mark: - Initializers
    
    init(accessToken: String, client: String, expiry: String, uid: String) {
        self.accessToken = accessToken
        self.client      = client
        self.expiry      = expiry
        self.uid         = uid
    }
    
    init(dictionary: [String : AnyObject]) {
        accessToken = dictionary[CardMineClient.Constants.Auth.Keys.AccessToken] as! String
        client      = dictionary[CardMineClient.Constants.Auth.Keys.Client]      as! String
        expiry      = dictionary[CardMineClient.Constants.Auth.Keys.Expiry]      as! String
        uid         = dictionary[CardMineClient.Constants.Auth.Keys.UID]         as! String
    }
    
    // Mark: - Methods
    
    func persist() {
    }
    
    func retrieve() {
    }
}
