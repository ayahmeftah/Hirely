//
//  FlaggedJobsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class FlaggedJobsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyPhoto: UIImageView!
    
    @IBOutlet weak var jobTitle: UILabel!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var postStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.companyPhoto.layer.cornerRadius = companyPhoto.frame.size.width / 2
        companyPhoto.clipsToBounds = true
        // Initialization code
    }
    
    func configureBadge(for status: FlagState) {
        postStatus.backgroundColor = status.backgroundColor
        postStatus.textColor = status.textColor
        postStatus.text = status.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func flaggedInit(_ company: String, _ image: String, _ job: String){
        companyName.text = company
        jobTitle.text = job
        companyPhoto.image = UIImage(named: image)
    }
}
