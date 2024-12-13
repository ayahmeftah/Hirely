//
//  ScheduledInterviewsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ScheduledInterviewsTableViewCell: UITableViewCell {
    
    weak var parentViewController: UIViewController? // Reference to the parent VC

    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            // Perform a segue for the first button
            parentViewController?.performSegue(withIdentifier: "goToInterviewDetails", sender: self)
        case 2:
            // Perform a segue for the second button
            parentViewController?.performSegue(withIdentifier: "goToEditInterview", sender: self)
        default:
            print("Unhandled button tapped")
        }

    }
    
    @IBOutlet weak var applicantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeInterview(_ name: String) {
        applicantName.text = name
    }
    
}
