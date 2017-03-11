//
//  CardsCollectionViewCell.swift
//  CardMine
//
//  Created by Abdullah on 3/12/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
    // Mark: -  Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Mark: - Methods
    
    func setPlaceholder() {
    }
    
    func setImage(_ image: Data) {
        imageView.image = deserializePhoto(image)
    }
    
    private func deserializePhoto(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
