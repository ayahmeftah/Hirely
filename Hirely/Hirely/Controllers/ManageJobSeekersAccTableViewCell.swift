//
//  ManageJobSeekersAccTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class ManageJobSeekersAccTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobSeekerPic: UIImageView!
    
    @IBOutlet weak var jobSeekerName: UILabel!
    
    @IBOutlet weak var jobSeekerAccStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.jobSeekerPic.layer.cornerRadius = jobSeekerPic.frame.size.width / 2
        jobSeekerPic.clipsToBounds = true
        // Initialization code
    }
    
    // Function to configure the badge based on status
    func configureBadge(for status: AccountStatus) {
        jobSeekerAccStatus.backgroundColor = status.backgroundColor
        jobSeekerAccStatus.textColor = status.textColor
        jobSeekerAccStatus.text = status.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func seekersInit(_ name: String, _ image: String){
        jobSeekerName.text = name
        jobSeekerPic.image = UIImage(named: image)
    }
    
}
