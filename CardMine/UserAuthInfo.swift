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
    
    var currentUser: User?
    
    // Mark: - Initializers
    
    init(accessToken: String, client: String, expiry: String, uid: String, currentUser: User?) {
        self.accessToken = accessToken
        self.client      = client
        self.expiry      = expiry
        self.uid         = uid
        self.currentUser = currentUser
    }
    
    init(dictionary: [String : AnyObject]) {
        accessToken = dictionary[CardMineClient.Constants.Auth.Keys.AccessToken] as! String
        client      = dictionary[CardMineClient.Constants.Auth.Keys.Client]      as! String
        expiry      = dictionary[CardMineClient.Constants.Auth.Keys.Expiry]      as! String
        uid         = dictionary[CardMineClient.Constants.Auth.Keys.UID]         as! String
    }
    
    // Mark: - Methods
    
    func persist() {
        storeSet(key: "accessToken", value: accessToken)
        storeSet(key: "client", value: client)
        storeSet(key: "expiry", value: expiry)
        storeSet(key: "uid", value: uid)
        
        User.persistUser(user: currentUser!)
    }
    
    static func retrieve() -> UserAuthInfo? {
        let user = User.retrievetUser()

        if let _accessToken = storeGet("accessToken") {
            if let _client = storeGet("client") {
                if let _expiry = storeGet("expiry") {
                    if let _uid = storeGet("uid") {
                        return self.init(accessToken: _accessToken,
                                         client: _client,
                                         expiry: _expiry,
                                         uid: _uid, currentUser: user)
                    }
                }
            }
        }
        return nil
    }
    
    func reset() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "client")
        UserDefaults.standard.removeObject(forKey: "expiry")
        UserDefaults.standard.removeObject(forKey: "uid")
    }
    
    private static func storeGet(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    private func storeSet(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }    
}
