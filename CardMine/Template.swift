//
//  Template.swift
//  CardMine
//
//  Created by Abdullah on 3/17/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation


class Template {
    // Mark: - Properties
    
    var id: Int
    var name: String
    var image: String
    var description: String?
    var url: String
    var createdAt: Date
    var updatedAt: Date
    
    var imgObject: NSData?
    
    // Mark: - Initializers
    
    init(id: Int, name: String, image: String, description: String?, url: String, createdAt: Date,
        updatedAt: Date) {
        self.id             = id
        self.name           = name
        self.image          = image
        self.description    = description
        self.url            = url
        self.createdAt      = createdAt
        self.updatedAt      = updatedAt

        downloadImage(URL(string: self.url)!)
    }
    
    required init(dictionary: [String : Any]) {
        id          = dictionary[CardMineClient.Constants.JSONPayloadKeys.Id]           as! Int
        name        = dictionary[CardMineClient.Constants.JSONPayloadKeys.Name]         as! String
        image       = dictionary[CardMineClient.Constants.JSONPayloadKeys.Image]        as! String
        description = dictionary[CardMineClient.Constants.JSONPayloadKeys.Description]  as? String
        url         = dictionary[CardMineClient.Constants.JSONPayloadKeys.Url]          as! String
        createdAt   = (dictionary[CardMineClient.Constants.JSONPayloadKeys.CreatedAt]   as! String).toDate()!
        updatedAt   = (dictionary[CardMineClient.Constants.JSONPayloadKeys.UpdatedAt]   as! String).toDate()!

        downloadImage(URL(string: url)!)
    }

    static func buildList(_ list: [[String : Any]]) -> [Template] {
        var result = [Template]()
        
        for item in list {
            result.append(self.init(dictionary: item))
        }
        return result
    }
    
    // Mark: - Methods
    
    private func downloadImage(_ url: URL) {
        getImageAsync(url: url) { (data, response, error)  in
            guard let data = data, error == nil else {
                return
            }
            performAsync { self.imgObject = data as NSData }
        }
    }
}
