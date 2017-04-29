//
//  Card+CoreDataProperties.swift
//  CardMine
//
//  Created by Abdullah on 4/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card");
    }

    @NSManaged public var desc: String?
    @NSManaged public var draft: Bool
    @NSManaged public var id: Int32
    @NSManaged public var templateId: Int32
    @NSManaged public var title: String?
    @NSManaged public var textualContents: NSSet?

}

// MARK: Generated accessors for textualContents
extension Card {

    @objc(addTextualContentsObject:)
    @NSManaged public func addToTextualContents(_ value: TextualContent)

    @objc(removeTextualContentsObject:)
    @NSManaged public func removeFromTextualContents(_ value: TextualContent)

    @objc(addTextualContents:)
    @NSManaged public func addToTextualContents(_ values: NSSet)

    @objc(removeTextualContents:)
    @NSManaged public func removeFromTextualContents(_ values: NSSet)

}
