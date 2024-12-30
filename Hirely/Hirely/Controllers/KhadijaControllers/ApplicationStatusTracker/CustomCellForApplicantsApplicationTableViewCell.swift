//
//  CustomCellForApplicantsApplicationTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func didTapButton(companyId: String, jobId: String)
}

class CustomCellForApplicantsApplicationTableViewCell: UITableViewCell {

    @IBOutlet weak var jobPositionlbl: UILabel!
    @IBOutlet weak var jobCompany: UILabel!
    @IBOutlet weak var badgeimag: UIImageView!
    @IBOutlet weak var badgestatelbl: UILabel!
    @IBOutlet weak var badgeView: UIView!

    weak var delegate: CustomCellDelegate?
    var companyId: String = ""
    var jobId: String = ""

    // Action linked to the button in the storyboard
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(companyId: companyId, jobId: jobId)
    }
    
    

    // Configure the badge with the badge state
    func configureBadge(for state: BadgeState) {
        badgeView.backgroundColor = state.backgroundColor
        badgeView.layer.cornerRadius = 12
        badgeView.layer.masksToBounds = true
        badgestatelbl.text = state.text
        badgestatelbl.textColor = state.textColor
        badgeimag.image = state.icon
        badgeimag.tintColor = state.textColor

        // Calculate the width dynamically based on the text
//        let badgePadding: CGFloat = 16 // Padding around text
//        let textWidth = (badgestatelbl.text! as NSString).size(withAttributes: [
//            .font: badgestatelbl.font ?? UIFont.systemFont(ofSize: 17)
//        ]).width
//
//        let iconWidth: CGFloat = badgeimag.image == nil ? 0 : 20 // Adjust for icon size
//        let totalWidth = textWidth + iconWidth + badgePadding * 2
//
//        // Adjust the badge frame directly
//        if state == .scheduledInterview {
//            badgeView.frame.size.width = max(totalWidth, 150)
//        } else {
//            badgeView.frame.size.width = max(totalWidth, 100)
//        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func appliedInit(_ position: String, _ company: String, _ status: String) {
        jobPositionlbl.text = position
        jobCompany.text = company

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
