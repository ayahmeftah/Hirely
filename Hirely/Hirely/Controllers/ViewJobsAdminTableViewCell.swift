//
//  ViewJobsAdminTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit
import FirebaseFirestore

class ViewJobsAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    @IBOutlet weak var jobPostedDateLbl: UILabel!
    
    @IBOutlet weak var jobDeadlineDateLbl: UILabel!
    
    @IBOutlet weak var flagButton: UIButton!
    
    @IBAction func flagButtonTapped(_ sender: UIButton) {
        parentViewController?.performSegue(withIdentifier: "goToFlagJob", sender: self)

    }
    
    
    weak var parentViewController: UIViewController? //reference the parent view controller
    
    var jobId: String? //save the job id
    var isFlagged: Bool = false {
        didSet {
            updateFlagButtonIcon()
        }
    }

    @IBAction func buttonTapped(_ sender:UIButton){
        switch sender.tag{
        case 1:
            parentViewController?.performSegue(withIdentifier: "goToJobDetails", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // round image
        companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func postInit(_ company: String, _ jobType: String, _ jobTitle: String, _ image: String, _ postedDate: String, _ deadlineDate: String, _ jobId: String, _ isFlagged: Bool){
        companyImage.image = UIImage(named: image)
        jobTypeLbl.text = jobType
        jobTitleLbl.text = jobTitle
        companyNameLbl.text = company
        jobPostedDateLbl.text = postedDate
        jobDeadlineDateLbl.text = deadlineDate
        self.jobId = jobId
        self.isFlagged = isFlagged
        updateFlagButtonIcon()
    }
    
    private func updateFlagButtonIcon() {
        let iconName = isFlagged ? "flag.fill" : "flag"
        flagButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
        
    
}
