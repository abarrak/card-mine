//
//  TextualContent+CoreDataProperties.swift
//  CardMine
//
//  Created by Abdullah on 4/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import CoreData


extension TextualContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextualContent> {
        return NSFetchRequest<TextualContent>(entityName: "TextualContent");
    }

    @NSManaged public var color: String?
    @NSManaged public var content: String?
    @NSManaged public var fontFamily: String?
    @NSManaged public var fontSize: String?
    @NSManaged public var height: Int32
    @NSManaged public var id: Int32
    @NSManaged public var width: Int32
    @NSManaged public var x_position: Int32
    @NSManaged public var y_position: Int32
    @NSManaged public var card: Card?

}
