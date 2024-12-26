//
//  FilterOptionTableViewCell.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import UIKit

class FilterOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    
    @IBOutlet weak var filterOptionLbl: UILabel!
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
        print("Checkbox tapped for: \(filterOptionLbl.text ?? "")")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func filterInit(_ filterOption: String){
        filterOptionLbl.text = filterOption
    }
}
