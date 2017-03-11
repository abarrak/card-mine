//
//  CardsTableViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/12/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Mark: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // tableView.reloadData()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return Card.all?.count ?? 0
        return 0
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsInfoCell",
                                                 for: indexPath)
    
        // let card = Card.find(indexPath.row)
        cell.imageView?.image = UIImage(named: "")
        cell.textLabel?.text = "None"
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: open card in designer or viewer ..
    }
}
