//
//  CustomJobPostTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class CustomJobPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var unhideIcon: UIImageView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var editIcon: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    @IBOutlet weak var applicantsLbl: UILabel!
    
    @IBOutlet weak var postedLbl: UILabel!
    
    @IBOutlet weak var deadlineLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(_ company: String, _ companyImg: String, _ jobTitle: String, _ jobType: String){
        
        companyImage.image = UIImage(named: companyImg)
        
//        unhideIcon.image = UIImage(named: hideIcon)
//        
//        deleteIcon.image = UIImage(named: trashIcon)
//        
//        editIcon.image = UIImage(named: penIcon)
        
        companyLbl.text = company
        jobTitleLbl.text = jobTitle
        jobTypeLbl.text = jobType
    }
    
}
