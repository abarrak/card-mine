//
//  CardsCollectionViewController.swift
//  CardMine
//
//  Created by Abdullah on 4/14/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // Mark: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var galleryTabBarItem: UITabBarItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGallery()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        retainNavTitle()
    }

    // Mark: - Methods
    
    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        setFlowLayout()
        colorizeTabBarItem()
    }
    
    private func setFlowLayout() {
        let interSpace: CGFloat = 9.0
        let lineSpace: CGFloat = 10.0
        let dimension = (view.frame.size.width - (2 * interSpace)) / 3.0
                
        flowLayout.minimumInteritemSpacing = interSpace
        flowLayout.minimumLineSpacing = lineSpace
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    private func colorizeTabBarItem() {
        let selected   = galleryTabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        galleryTabBarItem.selectedImage = selected
        
        let darkRed = UIColor(red: 128.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let attributes = [ NSForegroundColorAttributeName : darkRed ]
        
        galleryTabBarItem?.setTitleTextAttributes(attributes , for: .selected)
    }

    private func retainNavTitle() {
        tabBarController?.navigationItem.title = "All Cards"
    }
    
    private func configureGallery() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.listenToTemplatesArrival),
                                               name: NSNotification.Name(AllTemplates.templatesNotificationId),
                                               object: nil)
    }

    // Mark: - Actions & Protocols
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return AllTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardsCollectionViewCell",
                                                      for: indexPath) as! CardsCollectionViewCell
        
        if let image = AllTemplates.templates[indexPath.row].imgObject {
            cell.setImage(image as Data)
        } else {
            cell.setPlaceholder()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let designerVC = storyboard?.instantiateViewController(withIdentifier: "cardDesigner")
                         as! CardDesignerViewController
        navigationController?.pushViewController(designerVC, animated: true)
        designerVC.navToImageIndex = indexPath.row
    }
    
    func listenToTemplatesArrival() {
        collectionView.reloadData()
    }
    
}
