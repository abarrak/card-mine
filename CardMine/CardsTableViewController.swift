//
//  CardsTableViewController.swift
//  CardMine
//
//  Created by Abdullah on 3/12/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreData


class CardsTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    
    // Mark: - Properties
    
    @IBOutlet weak var listTabBarItem: UITabBarItem!
    var selectedCard: FinalCard?

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    // Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "FinalCard")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        let fc = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: context,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil)
        fetchedResultsController = fc
        fetchedResultsController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFinalCards()
        setupUI()
        retainNavTitle()
    }

    // MARK: - Actions & Protocol
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            if let objects = fc.fetchedObjects {
                return objects.count
            }
        }
        return 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let fc = fetchedResultsController {
            if let sections = fc.sections {
                return sections.count
            }
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let finalCard = fetchedResultsController?.object(at: indexPath) as? FinalCard

        let cell = tableView.dequeueReusableCell(withIdentifier: "cardsTableViewCell",
                                                      for: indexPath)

        cell.imageView?.image = UIImage(data: (finalCard?.imgObject as! Data))
        cell.textLabel?.text = finalCard?.title


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(fetchedResultsController?.fetchedObjects?.count)
        print(fetchedResultsController?.fetchedObjects ?? "D")

        selectedCard = FinalCard.find(indexPath.row + 1, context: context)
        if let _ = selectedCard {
            performSegue(withIdentifier: "presentCardViewer", sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let cardToDelete = FinalCard.find(indexPath.row + 1, context: context) {
                context.delete(cardToDelete)
                saveInStore()
            }
            FinalCard.recalculateIds(context)
            saveInStore()
            loadFinalCards()
        }
            // other way of doing it ..
            // tableView.beginUpdates()
            // tableView.deleteRows(at: [indexPath], with: .fade)
            // tableView.endUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentCardViewer" {
            let controller = segue.destination as! CardViewerViewController
            controller.setCard(selectedCard!)
        }
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

    private func retainNavTitle() {
        tabBarController?.navigationItem.title = "My Cards"
    }

    private func loadFinalCards() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                tableView.reloadData()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}
