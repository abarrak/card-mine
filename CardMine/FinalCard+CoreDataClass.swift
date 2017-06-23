//
//  FinalCard+CoreDataClass.swift
//  CardMine
//
//  Created by Abdullah on 6/16/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreData

@objc(FinalCard)
public class FinalCard: NSManagedObject {

    convenience init(title: String, image: UIImage, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "FinalCard", in: context) {
            self.init(entity: entity, insertInto: context)

            do {
                try self.id = Int32(FinalCard.count(context)!)
                self.title = title
                self.createdAt = NSDate()
                let data = UIImagePNGRepresentation(image) as NSData?
                self.imgObject = data
            } catch {
                print("Saving failed ...")
            }
        } else {
            fatalError("DB error: could not find entity model name.")
        }
    }

    // Mark: - Finders

    static func all(_ context: NSManagedObjectContext) -> [FinalCard]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FinalCard")
        do {
            let results = try context.fetch(fetchRequest) as! [FinalCard]
            return results
        } catch {
            return nil
        }
    }

    static func find(_ id: Int, context: NSManagedObjectContext) -> FinalCard? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FinalCard")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest) as! [FinalCard]
            print(results)
            return results.first
        } catch {
            return nil
        }
    }

    static func count(_ context: NSManagedObjectContext) throws -> Int? {
        if let fcs = FinalCard.all(context) {
            return fcs.count
        } else {
            fatalError("Can't generate ids")
        }
    }
}
