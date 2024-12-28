//
//  InterviewInfoTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-04 on 27/12/2024.
//

import UIKit

class InterviewInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Allow multi-line for infoLabel
        //infoLabel.numberOfLines = 0
        //infoLabel.lineBreakMode = .byWordWrapping
    }
}

