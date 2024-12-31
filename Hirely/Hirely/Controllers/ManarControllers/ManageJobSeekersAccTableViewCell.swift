//
//  ManageJobSeekersAccTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit
import Cloudinary

class ManageJobSeekersAccTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobSeekerPic: CLDUIImageView!
    
    @IBOutlet weak var jobSeekerName: UILabel!
    
    @IBOutlet weak var jobSeekerAccStatus: UILabel!
    
    weak var parentViewController: UIViewController? //reference the parent view controller
    
    // Cloudinary configuration
        let cloudName: String = "drkt3vace"
        let uploadPreset: String = "unsigned_upload"
        var cloudinary: CLDCloudinary!

    @IBAction func buttonTapped(_ sender:UIButton){
        switch sender.tag{
        case 1:
            parentViewController?.performSegue(withIdentifier: "goToApplicantDetails", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.jobSeekerPic.layer.cornerRadius = jobSeekerPic.frame.size.width / 2
        jobSeekerPic.clipsToBounds = true
        // Initialization code
        initCloudinary()
    }
    
    func initCloudinary() {
       let config = CLDConfiguration(cloudName: cloudName, secure: true)
       cloudinary = CLDCloudinary(configuration: config)
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
        jobSeekerPic.cldSetImage(image, cloudinary: cloudinary)
    }
    
}
