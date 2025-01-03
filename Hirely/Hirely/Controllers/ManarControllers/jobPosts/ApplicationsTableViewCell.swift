//
//  ApplicationsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ApplicationsTableViewCell: UITableViewCell {
    
    weak var parentViewController: UIViewController? //Reference to the parent VC
    private var badgeState: BadgeState = .new //Default status to new
    var viewButtonTapped: (() -> Void)? // Closure for button action

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Trigger the closure to notify the parent VC
        viewButtonTapped?()
    }
    
    @IBOutlet weak var applicantImage: UIImageView!
    @IBOutlet weak var applicantLbl: UILabel!
    @IBOutlet weak var badgeContainerView: UIView!
    @IBOutlet weak var badgeIconImageView: UIImageView!
    @IBOutlet weak var badgeTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round the applicant image
        self.applicantImage.layer.cornerRadius = applicantImage.frame.size.width / 2
        applicantImage.clipsToBounds = true
    }
    
    
    //Configure badge with badge state
    func configureBadge(for state: BadgeState) {
        badgeContainerView.backgroundColor = state.backgroundColor
        badgeContainerView.layer.cornerRadius = 12
        badgeContainerView.layer.masksToBounds = true
        badgeTextLabel.text = state.text
        badgeTextLabel.textColor = state.textColor
        badgeIconImageView.image = state.icon
        badgeIconImageView.tintColor = state.textColor
        
        //Calculate the width dynamically based on the text
        let badgePadding: CGFloat = 16 // Padding around text
        let textWidth = (badgeTextLabel.text! as NSString).size(withAttributes: [
            .font: badgeTextLabel.font ?? UIFont.systemFont(ofSize: 17)
        ]).width
        
        let iconWidth: CGFloat = badgeIconImageView.image == nil ? 0 : 20 // Adjust for icon size
        let totalWidth = textWidth + iconWidth + badgePadding * 2
        
        //Adjust the badge frame directly
        if state == .scheduledInterview {
            badgeContainerView.frame.size.width = max(totalWidth, 150)
        } else {
            badgeContainerView.frame.size.width = max(totalWidth, 100)
        }
    }
    
    func configure(with application: JobApplication) {
        applicantLbl.text = application.fullName
        applicantImage.image = UIImage(named: "khalid")
        //configure badge state based on application status
        switch application.applicationStatus.lowercased() {
        case "reviewed": badgeState = .reviewed
        case "new": badgeState = .new
        case "hired": badgeState = .hired
        case "scheduled interview": badgeState = .scheduledInterview
        case "rejected": badgeState = .rejected
        default: badgeState = .new //Default new
        }
        
        configureBadge(for: badgeState)
    }    
        
    }
    

