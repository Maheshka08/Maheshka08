//
//  PageControlCollectionViewCell.swift
//  Tweak and Eat
//
//  Created by mac on 27/03/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class PageControlCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @objc var cellIndexPath : Int = 0
    @objc var myIndexPath : IndexPath!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.5
        self.scrollView.backgroundColor = UIColor.black
        self.scrollView.delegate = self
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.clipsToBounds = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }

}
