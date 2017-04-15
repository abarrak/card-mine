//
//  CardsCollectionViewController.swift
//  CardMine
//
//  Created by Abdullah on 4/14/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsCollectionViewController: UICollectionViewController {

    // Mark: - Properties
    
    @IBOutlet weak var galleryTabBarItem: UITabBarItem!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    // Mark: - Methods
    
    private func setupUI() {
        setFlowLayout()
        colorizeTabBarItem()
    }
    
    private func setFlowLayout() {
        let interSpace: CGFloat = 6.0
        let lineSpace: CGFloat = 7.0
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
    
    // Mark: - Actions & Protocols

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardsCollectionViewCell",
                                                      for: indexPath) as! CardsCollectionViewCell
        cell.setPlaceholder()
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
