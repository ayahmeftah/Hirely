//
//  ExperienceTableViewCell.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(){
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        
    }
    
    

}
