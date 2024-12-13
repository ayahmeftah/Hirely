//
//  CustomJobPostTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit


class CustomJobPostTableViewCell: UITableViewCell {
    
    weak var parentViewController: UIViewController? // Reference to the parent VC

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
        default:
            print("Unhandled button tapped")
        }

    }
    
    @IBOutlet weak var companyImage: UIImageView!
    
    @IBOutlet weak var unhideIcon: UIImageView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var editIcon: UIImageView!
    
    @IBOutlet weak var jobTitleLbl: UILabel!
    
    @IBOutlet weak var companyLbl: UILabel!
    
    @IBOutlet weak var jobTypeLbl: UILabel!
    
    @IBOutlet weak var applicantsLbl: UILabel!
    
    @IBOutlet weak var postedLbl: UILabel!
    
    @IBOutlet weak var deadlineLbl: UILabel!
    

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
    
    func commonInit(_ company: String, _ companyImg: String, _ jobTitle: String, _ jobType: String){
        
        companyImage.image = UIImage(named: companyImg)
        
//        unhideIcon.image = UIImage(named: hideIcon)
//        
//        deleteIcon.image = UIImage(named: trashIcon)
//        
//        editIcon.image = UIImage(named: penIcon)
        
        companyLbl.text = company
        jobTitleLbl.text = jobTitle
        jobTypeLbl.text = jobType
    }
    


    
}
