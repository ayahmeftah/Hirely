//
//  ViewJobsAdminTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit

class ViewJobsAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // round image
        companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func postInit(_ company: String, _ jobType: String, _ jobTitle: String, _ image: String){
        companyImage.image = UIImage(named: image)
        jobTypeLbl.text = jobType
        jobTitleLbl.text = jobTitle
        companyNameLbl.text = company
    }
    
}
