//
//  Card+CoreDataClass.swift
//  CardMine
//
//  Created by Abdullah on 4/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {

    // Mark: - Initializers
    
    convenience init(id: Int32, title: String?, desc: String?, templateId: Int32, textualContents: NSSet?,
                     context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Card", in: context) {
            self.init(entity: entity, insertInto: context)
            self.id         = id
            self.title      = title
            self.desc       = desc
            self.templateId = templateId
            self.textualContents = textualContents
        } else {
            fatalError("DB error: could not find entity model name.")
        }
    }
    
    convenience init(_ dictionary: [String : Any], context: NSManagedObjectContext) {
        let _id         = dictionary[CardMineClient.Constants.JSONPayloadKeys.Id]          as! Int32
        let _title      = dictionary[CardMineClient.Constants.JSONPayloadKeys.Title]       as? String
        let _desc       = dictionary[CardMineClient.Constants.JSONPayloadKeys.Description] as? String
        let _templateId = dictionary[CardMineClient.Constants.JSONPayloadKeys.TemplateId]  as! Int32
        let _textualContents = dictionary[CardMineClient.Constants.JSONPayloadKeys.TextualContents]  as? NSSet
        
        self.init(id: _id, title: _title, desc: _desc, templateId: _templateId, textualContents: _textualContents, context: context)
    }
    
    // Mark: - Methods & Finders
    
    static func buildList(_ list: [[String : Any]], context: NSManagedObjectContext) -> [Card] {
        var result = [Card]()
        
        for item in list {
            result.append(Card(item, context: context))
        }
        return result
    }
    
    func toJSON() -> String {
        return ""
    }
}
