//
//  FullViewVC.swift
//  ApiIntegrationURLSession
//
//  Created by Sumayya Siddiqui on 18/03/23.
//

import UIKit

class FullViewVC: UIViewController {
    
    
    @IBOutlet var myPage: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
        }
    }
    
    var taskelement: [TaskElement] = []
    var selectedIndex: IndexPath?
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if selectedIndex != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                self.collectionView.scrollToItem(at: self.selectedIndex!, at: .right, animated: true)
            })
            
            
        }
        
        myPage.numberOfPages = taskelement.count
        
        
    }


}

extension FullViewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskelement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        let item = taskelement[indexPath.item]
        cell.imgView.imageFromUrl(urlString: item.url)
        cell.imgView.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        myPage.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


// MARK: ImageCell
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
        
}
