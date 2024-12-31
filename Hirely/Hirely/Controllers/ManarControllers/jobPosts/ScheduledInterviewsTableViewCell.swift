//
//  ScheduledInterviewsTableViewCell.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

protocol ScheduledInterviewsCellDelegate: AnyObject {
    func viewDetailsTapped(for interview: InterviewDetail)
}

class ScheduledInterviewsTableViewCell: UITableViewCell {
    
    weak var parentViewController: UIViewController? // Reference to the parent VC
    weak var delegate: ScheduledInterviewsCellDelegate? // Delegate for actions
        
    private var interview: InterviewDetail? // Store interview data

    
    @IBOutlet weak var applicantName: UILabel!
    
    @IBOutlet weak var interviewDateLabel: UILabel!
    
    @IBOutlet weak var interviewTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    // Configure the cell with interview data
       func configure(with interview: InterviewDetail, applicantName: String) {
           self.interview = interview
           self.applicantName.text = applicantName
           self.interviewDateLabel.text = DateFormatter.localizedString(from: interview.date.dateValue(), dateStyle: .medium, timeStyle: .none)
           self.interviewTimeLabel.text = DateFormatter.localizedString(from: interview.time.dateValue(), dateStyle: .none, timeStyle: .short)
       }

        // Button action setup
        @IBAction func viewDetailsTapped(_ sender: UIButton) {
            guard let interview = interview else { return }
                    delegate?.viewDetailsTapped(for: interview)
        }
    }
    

