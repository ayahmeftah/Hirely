//
//  JobsResultTableViewCell.swift
//  Hirely
//
//  Created by Ayah Meftah  on 24/12/2024.
//

import UIKit

class JobsResultTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var companyImg: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    @IBAction func viewJobBtn(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // round image
        companyImg.layer.cornerRadius = companyImg.frame.size.width / 2
        companyImg.clipsToBounds = true
        jobTypeLbl.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resultiInit(_ companyName: String, _ jobTitle: String, _ companyImage: String, _ jobType: String){
        companyImg.image = UIImage(named: companyImage)
        jobTitleLbl.text = jobTitle
        companyNameLbl.text = companyName
        jobTypeLbl.text = jobType
    }
}
