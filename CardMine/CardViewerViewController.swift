//
//  CardViewerViewController.swift
//  CardMine
//
//  Created by Abdullah on 4/10/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardViewerViewController: UIViewController {
    
    // Mark: - Properties
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark: - Actions & Protocols
    
    // Mark: - Methods
    
    @IBAction func share() {
        let card = renderScreenImage()
        
        let activityController = UIActivityViewController(activityItems: [card], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (type, completed, returnedItems, error) -> Void in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    func renderScreenImage() -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let screenImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return screenImage
    }
}
