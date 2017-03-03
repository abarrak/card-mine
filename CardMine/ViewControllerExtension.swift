//
//  ViewControllerExtension.swift
//  CardMine
//
//  Created by Abdullah on 2/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {

    var context: NSManagedObjectContext {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).stack.context
        }
    }

    // Utility for informational alert
    func alertMessage(_ title: String, message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let handler = completionHandler ?? { action in self.dismiss(animated: true, completion: nil) }        
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.default,
                                     handler: handler)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Utility for alert with question
    func alertQuestion(_ title: String, message: String, okHandler: @escaping (_ action: UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: title, message:message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okHandler))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Persist modification back to the database
    func saveInStore() {
        (UIApplication.shared.delegate as! AppDelegate).stack.save()
    }
}
