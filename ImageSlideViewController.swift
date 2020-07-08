//
//  ImageSlideViewController.swift
//  Tweak and Eat
//
//  Created by mac on 27/03/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class ImageSlideViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectionView: UIScrollView!
   // var imgView = UIImageView();
    @IBOutlet weak var pageControl: UIPageControl!
    
    @objc var imagesArray = [String]()
    @objc var frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = selectionView.contentOffset.x / selectionView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.selectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
//        self.view.addSubview(self.selectionView)
        self.selectionView.minimumZoomScale = 1.0
        self.selectionView.maximumZoomScale = 6.0
        self.pageControl.numberOfPages = self.imagesArray.count
        for index in 0..<self.imagesArray.count {
            frame.origin.x = selectionView.frame.width * CGFloat(index)
            frame.size = selectionView.frame.size
            imgView.frame = frame
            imgView.sd_setImage(with: URL(string: self.imagesArray[index] ));
            self.selectionView.addSubview(imgView)
            
        }
        selectionView.contentSize = CGSize(width: selectionView.frame.width * CGFloat(self.imagesArray.count), height: selectionView.frame.height)
        selectionView.delegate = self
    }

}
