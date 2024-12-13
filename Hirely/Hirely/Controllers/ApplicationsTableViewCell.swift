//
//  ApplicationsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ApplicationsTableViewCell: UITableViewCell {
    
    weak var parentViewController: UIViewController? // Reference to the parent VC

    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            // Perform a segue for the first button
            parentViewController?.performSegue(withIdentifier: "goToApplicantDetails", sender: self)
        default:
            print("Unhandled button tapped")
        }

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
    
    // Enum for badge states
    enum BadgeState {
        case reviewed
        case new
        case rejected
        case hired
        case scheduledInterview

        var backgroundColor: UIColor {
            switch self {
            case .reviewed: return UIColor(red: 212/255, green: 170/255, blue: 255/255, alpha: 1)
            case .new: return UIColor(red: 255/255, green: 196/255, blue: 98/255, alpha: 1)
            case .hired: return UIColor(red: 125/255, green: 222/255, blue: 134/255, alpha: 1)
            case .scheduledInterview: return UIColor(red: 196/255, green: 222/255, blue: 255/255, alpha: 1)
            case .rejected: return UIColor(red: 255/255, green: 152/255, blue: 152/255, alpha: 1)
            }
        }

        var text: String {
            switch self {
            case .reviewed: return "Reviewed"
            case .new: return "New"
            case .hired: return "Hired"
            case .scheduledInterview: return "Scheduled Interview"
            case .rejected: return "Rejected"
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .reviewed: return UIColor.purple
            case .new: return UIColor.brown
            case .hired: return UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
            case .scheduledInterview: return UIColor.blue
            case .rejected: return UIColor.red
            }
        }

        var icon: UIImage? {
            switch self {
            case .reviewed: return UIImage(systemName: "doc.text.magnifyingglass")
            case .new: return UIImage(systemName: "checklist")
            case .hired: return UIImage(systemName: "checkmark.circle.fill")
            case .scheduledInterview: return UIImage(systemName: "person.2.fill")
            case .rejected: return UIImage(systemName: "xmark.circle.fill")
            }
        }
    }
    
    // Configure badge with badge state
    func configureBadge(for state: BadgeState) {
        badgeContainerView.backgroundColor = state.backgroundColor
        badgeContainerView.layer.cornerRadius = 12
        badgeContainerView.layer.masksToBounds = true
        badgeTextLabel.text = state.text
        badgeTextLabel.textColor = state.textColor
        badgeIconImageView.image = state.icon
        badgeIconImageView.tintColor = state.textColor
        
        // Calculate the width dynamically based on the text
            let badgePadding: CGFloat = 16 // Padding around text
            let textWidth = (badgeTextLabel.text! as NSString).size(withAttributes: [
                .font: badgeTextLabel.font ?? UIFont.systemFont(ofSize: 17)
            ]).width

            let iconWidth: CGFloat = badgeIconImageView.image == nil ? 0 : 20 // Adjust for icon size
            let totalWidth = textWidth + iconWidth + badgePadding * 2

            // Adjust the badge frame directly
            if state == .scheduledInterview {
                badgeContainerView.frame.size.width = max(totalWidth, 150) // Wider for Scheduled Interview
            } else {
                badgeContainerView.frame.size.width = max(totalWidth, 100) // Default for other states
            }
    }

    // Initialize the cell with applicant data
    func applicantsInit(_ applicantName: String, _ status: String) {
        applicantLbl.text = applicantName
        let badgeState: BadgeState
        
        switch status.lowercased() {
        case "reviewed": badgeState = .reviewed
        case "new": badgeState = .new
        case "hired": badgeState = .hired
        case "scheduled interview": badgeState = .scheduledInterview
        case "rejected": badgeState = .rejected
        default: badgeState = .new // Default state
        }
        
        configureBadge(for: badgeState)
    }
}

