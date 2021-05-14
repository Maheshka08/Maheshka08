//
//  PageViewImageSlider.swift
//  Tweak and Eat
//
//  Created by mac on 27/03/19.
//  Copyright © 2019 Purpleteal. All rights reserved.
//

import UIKit

class PageViewImageSlider: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var dateInfo = ""
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tweaksSwipe: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @objc var imagesArray = [String]()
    @objc var itemIndex = 0
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return imagesArray.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! PageControlCollectionViewCell
        cell.imgView.sd_setImage(with: URL(string: self.imagesArray[indexPath.item] ));
        cell.cellIndexPath = indexPath.item
//        cell.scrollView.minimumZoomScale = 1.0
        //itemIndex = indexPath.item
       // self.pageControl.updateCurrentPageDisplay()
        
        return cell;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollToParticularItem(myIndex: self.itemIndex)

    }
    
    @objc func scrollToParticularItem(myIndex: Int) {
         let index = IndexPath.init(item: myIndex, section: 0);
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        self.collectionView.layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.numberOfLines = 0
        self.dateLabel.text = dateInfo
        self.dateLabel.textAlignment = .center
    self.collectionView.delegate = self
        self.view.backgroundColor = .black
        self.collectionView.dataSource = self;
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = imagesArray.count
        pageControl.currentPage = itemIndex;
        pageControl.isUserInteractionEnabled = false
        pageControl.transform = CGAffineTransform (scaleX: 1.5, y: 1.5);
        
        if imagesArray.count == 1 {
            pageControl.isHidden = true

        } else {
            pageControl.isHidden = false

        }
 
    }
    
//     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
//        let index = scrollView.contentOffset.x / witdh
//        let roundedIndex = round(index)
//        self.pageControl?.currentPage = Int(roundedIndex)
//    }
    
}

extension PageViewImageSlider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
