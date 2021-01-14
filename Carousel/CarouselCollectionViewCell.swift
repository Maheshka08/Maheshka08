//
//  CarouselCollectionViewCell.swift
//  CarouselExample
//
//  Created by Kumar, Sumit on 25/03/20.
//  Copyright © 2020 sk. All rights reserved.
//

import UIKit
protocol CarouselButtonDelegate1 {
    func cellTappedOnButton(_ cell: CarouselCollectionViewCell)
    
}
class CarouselCollectionViewCell: UICollectionViewCell {
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    var buttonDelegate: CarouselButtonDelegate1?
    // MARK: - IBOutlets
    
    @IBOutlet weak var btnImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    @IBAction func btnAction(_ sender: Any) {
                   if let delegate = buttonDelegate {
               delegate.cellTappedOnButton(self);
           }
       }
    
    // MARK: - Custom methods
    /// Method to populate the secondary view with the recommendation detail
    /// - Parameter recommendation: Recommendation object
    func populate(item: Item) {
//        textLabel.text = "Item: " + item.value
        DispatchQueue.global(qos: .background).async {
            // Call your background task
            let imgUrl = item.value
            let data = try? Data(contentsOf: URL(string: imgUrl)!)
            // UI Updates here for task complete.
           
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                       
                        self.btnImage.setImage(image, for: .normal)
                    
                    
                    
                }
        }
        

            
        }

    }
}
