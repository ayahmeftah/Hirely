//
//  FiltersCollectionViewCell.swift
//  Hirely
//
//  Created by Ayah Meftah  on 24/12/2024.
//

import UIKit

class FiltersCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var filterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Style the label
        filterLbl.textAlignment = .center
        filterLbl.font = UIFont.boldSystemFont(ofSize: 14) // Adjust font size if necessary
        filterLbl.textColor = .white // Ensure text is visible against the background
        filterLbl.adjustsFontSizeToFitWidth = true // Shrink text to fit if necessary
        filterLbl.minimumScaleFactor = 0.7 // Minimum scaling for text
    }
    
    func postInit(_ filterName: String) {
        filterLbl.text = "\(filterName) ▼"
    }

}
