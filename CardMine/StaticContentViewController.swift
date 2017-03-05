//
//  StaticContentViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/4/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class StaticContentViewController: UIViewController {
    // Mark: - Properties
    
    enum StaticPage {
        case about
        case contact
    }
    var requestedPage: StaticPage?

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pagePhoto: UIImageView!
    @IBOutlet weak var pageContent: UITextView!
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        turnToPage()
    }
    
    // Mark: - Actions & Protocols
    
    @IBAction func closePage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        pageContent.font = pageContent.font?.withSize(CGFloat(sender.value))
    }
    
    // Mark: - Methods
    
    private func turnToPage() {
        switch requestedPage! {
        case .about:
            setupPage("About")
        case .contact:
            setupPage("Contact")
        }
    }
    
    private func setupPage(_ name: String) {
        pageTitle.text = name
        pagePhoto.image = UIImage(named: "\(name) Photography")
    }
    
    // Mark: - Resolve Keyboard/UI issue
    
    // Mark: - Helpers
}
