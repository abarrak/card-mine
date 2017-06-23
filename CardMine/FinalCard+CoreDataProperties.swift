//
//  FinalCard+CoreDataProperties.swift
//  CardMine
//
//  Created by Abdullah on 6/17/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import CoreData

extension FinalCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinalCard> {
        return NSFetchRequest<FinalCard>(entityName: "FinalCard");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var imgObject: NSData?
    @NSManaged public var title: String?

}
