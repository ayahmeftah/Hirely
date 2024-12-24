//
//  ResultsPageViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 24/12/2024.
//

import UIKit

class ResultsPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    let filters = ["Job Type", "Experience Level", "Location Type", "Salary Range"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FiltersCollectionViewCell", bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: "FilterCell")
        
        // Set delegate and data source for collection view
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FiltersCollectionViewCell
        cell.postInit(filters[indexPath.item]) // Set label text
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
       /* cell.contentView.backgroundColor = .gray*/ // Update background color
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dynamically calculate the label's width based on its content
        let labelWidth = filters[indexPath.item].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
        let cellHeight: CGFloat = 40 // Fixed height for the cell
        return CGSize(width: labelWidth + 40, height: cellHeight) // Add padding to the width
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = filters[indexPath.item]
        print("Selected Filter: \(selectedFilter)")
    }
}
