//
//  ManageEmployersTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit
import Cloudinary

class ManageEmployersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employerImage: CLDUIImageView!
    
    @IBOutlet weak var employerNameLbl: UILabel!
    
    @IBOutlet weak var employerAccStatus: UILabel!
    
    weak var parentViewController: UIViewController? //reference the parent view controller
    
    // Cloudinary configuration
        let cloudName: String = "drkt3vace"
        let uploadPreset: String = "unsigned_upload"
        var cloudinary: CLDCloudinary!
    
    @IBAction func buttonTapped(_ sender:UIButton){
        switch sender.tag{
        case 1:
            parentViewController?.performSegue(withIdentifier: "goToEmployerAccount", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.employerImage.layer.cornerRadius = employerImage.frame.size.width / 2
        employerImage.clipsToBounds = true
        // Initialization code
        initCloudinary()
    }
    
    func initCloudinary() {
       let config = CLDConfiguration(cloudName: cloudName, secure: true)
       cloudinary = CLDCloudinary(configuration: config)
   }
    
    // Function to configure the badge based on status
    func configureBadge(for status: AccountStatus) {
        employerAccStatus.backgroundColor = status.backgroundColor
        employerAccStatus.textColor = status.textColor
        employerAccStatus.text = status.text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func employersInit(_ name: String, _ image: String){
        employerNameLbl.text = name
        employerImage.cldSetImage(image, cloudinary: cloudinary)
    }
    
}
