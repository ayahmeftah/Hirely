//
//  CustomJobPostTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit


class CustomJobPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hideButton: UIButton!
    
    weak var parentViewController: UIViewController? // Reference to the parent VC
    var parentController: JobPostingViewController?
    var jobPosting: JobPosting?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            // Perform a segue for the first button
            parentViewController?.performSegue(withIdentifier: "goToDetails", sender: self)
        case 2:
            // Perform a segue for the second button
            parentViewController?.performSegue(withIdentifier: "goToApplicants", sender: self)
            
        case 3:
            // Perform a segue for the third button
            parentViewController?.performSegue(withIdentifier: "editJobDetails", sender: self)
            
        case 4:
                    //delete button
                    guard let jobPosting = jobPosting, let parentVC = parentController else { return }
                    parentVC.deleteJobPosting(jobPosting: jobPosting) //call delete method in the parent VC
            
        case 5:
            // Hide/Unhide button tapped
                   guard let jobPosting = jobPosting, let parentVC = parentController else { return }
                   let newIsHidden = !jobPosting.isHidden
                   parentVC.toggleJobVisibility(jobPosting: jobPosting, newIsHidden: newIsHidden)
                   let newIcon = newIsHidden ? "eye.slash.fill" : "eye.fill"
                   hideButton.setImage(UIImage(systemName: newIcon), for: .normal)
        default:
            print("Unhandled button tapped")
        }

    }
    
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    @IBOutlet weak var applicantsLbl: UILabel!
    
    @IBOutlet weak var postedLbl: UILabel!
    
    @IBOutlet weak var deadlineLbl: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    

    @IBAction func ViewApplicantsBtnTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func EditPostBtnTapped(_ sender: UIButton) {
    }
    
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
    
    func commonInit(_ company: String, _ companyImg: String, _ jobTitle: String, _ jobType: String, _ datePosted: String, _ deadlineDate: String, _ applicantsCount: String){
        companyImage.image = UIImage(named: companyImg)
        companyLbl.text = company
        jobTitleLbl.text = jobTitle
        jobTypeLbl.text = jobType
        postedLbl.text = datePosted
        deadlineLbl.text = deadlineDate
        applicantsLbl.text = applicantsCount
    }
}
