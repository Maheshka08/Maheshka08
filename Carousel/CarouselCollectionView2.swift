//
//  CarouselCollectionView2.swift
//  CarouselExample
//
//  Created by Kumar, Sumit on 25/03/20.
//  Copyright © 2020 sk. All rights reserved.
//

import Foundation
import UIKit


/// Class to represent carousel collection view configuration
/// Subclass this to inherit standard carousel view config
class CarouselCollectionView2: UICollectionView {
    
    override func awakeFromNib() {
    super.awakeFromNib()
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        self.decelerationRate = .fast
        
        /// Setting up the carousel flow layout
        let carouselFlowLayout = CarouselAnimatedFlowLayout()
        carouselFlowLayout.cellOffset = 45
        carouselFlowLayout.minLineSpacing = 6.0
        /// Zoom Level -- `10%`
        carouselFlowLayout.zoomLevel = 0.88
        
        self.collectionViewLayout = carouselFlowLayout
    }
}
