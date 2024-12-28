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
    @IBOutlet weak var jobPostedDateLbl: UILabel!
    @IBOutlet weak var jobDeadlineDateLbl: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var jobId: String? //save the job id
    var isSaved: Bool = false {
        didSet {
            updateBookmarkButtonIcon()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.backgroundColor = .clear

        
        jobTitleLbl.adjustsFontForContentSizeCategory = true
        companyNameLbl.adjustsFontForContentSizeCategory = true
        jobTypeLbl.adjustsFontForContentSizeCategory = true
        
        // Rounding the image
        self.companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
    }
    
    func postInit(_ company: String, _ jobType: String, _ jobTitle: String, _ image: String, _ postedDate: String, _ deadlineDate: String, _ jobId: String, _ isSaved: Bool) {
        companyImage.image = UIImage(named: image)
        jobTypeLbl.text = jobType
        jobTitleLbl.text = jobTitle
        companyNameLbl.text = company
        jobPostedDateLbl.text = postedDate
        jobDeadlineDateLbl.text = deadlineDate
        self.jobId = jobId
        self.isSaved = isSaved
        updateBookmarkButtonIcon()
    }
    
    private func updateBookmarkButtonIcon() {
        let iconName = isSaved ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

}
