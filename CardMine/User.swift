//
//  User.swift
//  CardMine
//
//  Created by Abdullah on 3/17/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation


struct User {
    // Mark: - Properties
    
    var id: Int
    var email: String
    var nickname: String
    var firstName: String?
    var lastName: String?
    
    var createdAt: Date
    var updatedAt: Date
    
    // Mark: - Initializers
    
    init(id: Int, email: String, nickname: String, firstName: String?, lastName: String?,
         createdAt: Date, updatedAt: Date) {
        self.id         = id
        self.email      = email
        self.nickname   = nickname
        self.firstName  = firstName
        self.lastName   = lastName
        self.createdAt  = createdAt
        self.updatedAt  = updatedAt
    }
    
    init(dictionary: [String : AnyObject]) {
        id          = dictionary[CardMineClient.Constants.JSONPayloadKeys.Id]           as! Int
        email       = dictionary[CardMineClient.Constants.JSONPayloadKeys.Email]        as! String
        nickname    = dictionary[CardMineClient.Constants.JSONPayloadKeys.Nickname]     as! String
        firstName   = dictionary[CardMineClient.Constants.JSONPayloadKeys.FirstName]    as? String
        lastName    = dictionary[CardMineClient.Constants.JSONPayloadKeys.LastName]     as? String
        createdAt   = (dictionary[CardMineClient.Constants.JSONPayloadKeys.CreatedAt]   as! String).toDate()!
        updatedAt   = (dictionary[CardMineClient.Constants.JSONPayloadKeys.UpdatedAt]   as! String).toDate()!
    }
}
