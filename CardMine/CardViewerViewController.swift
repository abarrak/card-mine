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

    var finalCard: FinalCard?

    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewCard()
    }
    
    // Mark: - Actions & Protocols

    @IBAction func share() {
        let activityController = UIActivityViewController(activityItems: [cardImage.image!],
                                                          applicationActivities: nil)

        activityController.completionWithItemsHandler = {
            (type, completed, returnedItems, error) -> Void in
            if completed {
                if error == nil {
                    self.alertMessage("Shared", message: "Your card has been shared successfully.")
                } else {
                    self.alertMessage("Error", message: "Share failed. Please try again.")

                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }

    // Mark: - Methods

    func setCard(_ card: FinalCard) {
        finalCard = card
    }

    private func previewCard() {
        if let card = finalCard {
            cardImage.image = UIImage(data: card.imgObject as! Data)!
            cardTitle.text = card.title!
            createdAtLabel.text = (card.createdAt as! Date).toString()
        }
    }
}
