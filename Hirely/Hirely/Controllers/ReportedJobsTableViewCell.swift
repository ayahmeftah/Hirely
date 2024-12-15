//
//  ReportedJobsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class ReportedJobsTableViewCell: UITableViewCell {

    @IBOutlet weak var companyPic: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var companyName: UILabel!
    
    weak var parentViewController: UIViewController? //reference the parent view controller
    
    @IBAction func buttonTapped(_ sender:UIButton){
        switch sender.tag{
        case 1:
            parentViewController?.performSegue(withIdentifier: "goToReportDetails", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // round image
        companyPic.layer.cornerRadius = companyPic.frame.size.width / 2
        companyPic.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reportediInit(_ company: String, _ job: String, _ companyPicture: String){
        
        companyPic.image = UIImage(named: companyPicture)
        jobName.text = job
        companyName.text = company
    }
    
}
