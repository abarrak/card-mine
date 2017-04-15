//
//  CardsTableViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/12/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsTableViewController : UITableViewController {
    
    // Mark: - Properties
    
    @IBOutlet weak var listTabBarItem: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // tableView.reloadData()
        setupUI()
    }
    
    // Mark: - Methods
    
    private func setupUI() {
        colorizeTabBarItem()
    }
    
    private func colorizeTabBarItem() {
        let selected   = listTabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        listTabBarItem.selectedImage = selected

        let darkRed = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let attributes = [ NSForegroundColorAttributeName : darkRed ]
        
        listTabBarItem?.setTitleTextAttributes(attributes , for: .selected)
    }
    
    // MARK: - Actions & Protocol

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return Card.all?.count ?? 0
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsInfoCell",
                                                 for: indexPath)
    
        // let card = Card.find(indexPath.row)
        cell.imageView?.image = UIImage(named: "")
        cell.textLabel?.text = "None"
    
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: open card in designer or viewer ..
    }
}
