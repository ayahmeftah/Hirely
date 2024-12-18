//
//  JobsCollectionViewCell.swift
//  Hirely
//
//  Created by Ayah Meftah  on 15/12/2024.
//

import UIKit

class JobsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Rounding the image
        self.companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
    }
    
    func postInit(_ company: String, _ jobType: String, _ jobTitle: String, _ image: String) {
        companyImage.image = UIImage(named: image)
        jobTypeLbl.text = jobType
        jobTitleLbl.text = jobTitle
        companyNameLbl.text = company
    }

}
