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
    
    weak var parentViewController: UIViewController? //reference the parent view controller
    
    @IBAction func buttonTapped(_ sender:UIButton){
        switch sender.tag{
        case 1:
            parentViewController?.performSegue(withIdentifier: "goToFlagInfo", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
    
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
//        postStatus.text = status.text
        postStatus.text = status.rawValue // Display the status text

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Update cell UI based on flagged job data
    func flaggedInit(_ company: String, _ image: String, _ job: String, _ status: FlagState) {
        companyName.text = company // Placeholder company name
        jobTitle.text = job // Dynamically fetched job title
        companyPhoto.image = UIImage(named: image) // Placeholder image
        configureBadge(for: status) // Set the badge based on the status
    }

        
//        // Configure badge UI for the flag status
//        private func configureBadge(for status: FlagState) {
//            postStatus.backgroundColor = status.backgroundColor
//            postStatus.textColor = status.textColor
//            postStatus.text = status.rawValue // Display the status text
//        }
}
