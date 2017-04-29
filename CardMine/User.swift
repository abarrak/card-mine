//
//  User.swift
//  CardMine
//
//  Created by Abdullah on 3/17/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

class User {
    // Mark: - Properties
    
    var id: Int
    var email: String
    var nickname: String
    var firstName: String?
    var lastName: String?
    
    // Mark: - Initializers
    
    init(id: Int, email: String, nickname: String, firstName: String?, lastName: String?) {
        self.id         = id
        self.email      = email
        self.nickname   = nickname
        self.firstName  = firstName
        self.lastName   = lastName
    }
    
    init(dictionary: [String : AnyObject]) {
        id          = dictionary[CardMineClient.Constants.JSONPayloadKeys.Id]           as! Int
        email       = dictionary[CardMineClient.Constants.JSONPayloadKeys.Email]        as! String
        nickname    = dictionary[CardMineClient.Constants.JSONPayloadKeys.Nickname]     as! String
        firstName   = dictionary[CardMineClient.Constants.JSONPayloadKeys.FirstName]    as? String
        lastName    = dictionary[CardMineClient.Constants.JSONPayloadKeys.LastName]     as? String
    }

    // Mark: - Methods

    static func persistUser(user: User) {
        UserDefaults.standard.set(user.id, forKey: "currentUser[id]")
        UserDefaults.standard.set(user.email, forKey: "currentUser[email]")
        UserDefaults.standard.set(user.nickname, forKey: "currentUser[nickname]")
        UserDefaults.standard.set(user.firstName, forKey: "currentUser[firstName]")
        UserDefaults.standard.set(user.lastName, forKey: "currentUser[lastName]")
    }
    
    static func retrievetUser() -> User? {
        let i = UserDefaults.standard.integer(forKey: "currentUser[id]")
        let e = UserDefaults.standard.string(forKey: "currentUser[email]")
        let n = UserDefaults.standard.string(forKey: "currentUser[nickname]")
        let f = UserDefaults.standard.string(forKey: "currentUser[firstName]")
        let l = UserDefaults.standard.string(forKey: "currentUser[lastName]")
        
        return e != nil && n != nil ? User(id: i, email: e!, nickname: n!, firstName: f, lastName: l) : nil
    }
}
