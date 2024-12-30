//
//  SkillTableViewCell.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 09/12/2024.
//

import UIKit

class SkillTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skillNameLabel: UILabel!
    
    @IBOutlet weak var checkUncheckBtn: UIButton!{
        didSet{
            checkUncheckBtn.addTarget(self, action: #selector(checkUncheckBtnTapped), for: .touchUpInside)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func checkUncheckBtnTapped(){
        checkUncheckBtn.isSelected.toggle()
    }

}
