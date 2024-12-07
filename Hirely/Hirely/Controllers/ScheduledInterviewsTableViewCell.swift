//
//  ScheduledInterviewsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ScheduledInterviewsTableViewCell: UITableViewCell {
    
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
