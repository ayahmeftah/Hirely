//
//  CustomJobPostTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit


class CustomJobPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hideButton: UIButton!
    
    weak var parentViewController: UIViewController?
    var parentController: JobPostingViewController?
    var jobPosting: JobPosting?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
                parentViewController?.performSegue(withIdentifier: "goToDetails", sender: self)
            case 2:
                parentViewController?.performSegue(withIdentifier: "goToApplicants", sender: self)
            case 4:
                guard let jobPosting = jobPosting, let parentVC = parentController else { return }
                parentVC.deleteJobPosting(jobPosting: jobPosting)
            case 5:
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
        
    @IBOutlet weak var postedLbl: UILabel!
    
    @IBOutlet weak var deadlineLbl: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func EditPostBtnTapped(_ sender: UIButton) {
        guard let parentVC = parentViewController as? JobPostingViewController, let job = jobPosting else {
            print("Parent ViewController or JobPosting is nil")
            return
        }
        parentVC.performSegue(withIdentifier: "editJobDetails", sender: job)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round image
        self.companyImage.layer.cornerRadius = companyImage.frame.size.width / 2
        companyImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func commonInit(_ company: String, _ companyImg: String, _ jobTitle: String, _ jobType: String, _ datePosted: String, _ deadlineDate: String, _ job: JobPosting) {
        companyImage.image = UIImage(named: companyImg)
        companyLbl.text = company
        jobTitleLbl.text = jobTitle
        jobTypeLbl.text = jobType
        postedLbl.text = datePosted
        deadlineLbl.text = deadlineDate
        self.jobPosting = job // Set the jobPosting property
    }
}
