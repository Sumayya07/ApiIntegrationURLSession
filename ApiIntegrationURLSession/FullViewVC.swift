//
//  FullViewVC.swift
//  ApiIntegrationURLSession
//
//  Created by Sumayya Siddiqui on 18/03/23.
//

import UIKit

class FullViewVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
        }
    }
    
    var taskelement: [TaskElement] = []
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if selectedIndex != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                self.collectionView.scrollToItem(at: self.selectedIndex!, at: .right, animated: true)
            })
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FullViewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskelement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        let item = taskelement[indexPath.item]
        cell.imgView.imageFromUrl(urlString: item.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: ImageCell
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
