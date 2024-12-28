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
    
    var didSelectOption: ((String, Bool) -> Void)?

    
//    @IBAction func didTapCheckBox(_ sender: UIButton) {
//        sender.isSelected.toggle() // Toggle the selected state
//        updateCheckBoxImage(for: sender.isSelected) // Update the image based on the selected state
//        print("Checkbox tapped for: \(filterOptionLbl.text ?? "")")
//    }
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateCheckBoxImage(for: sender.isSelected)
        if let option = filterOptionLbl.text {
            didSelectOption?(option, sender.isSelected) // Pass option and selection state
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set the initial checkbox image
        updateCheckBoxImage(for: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func filterInit(_ filterOption: String) {
        filterOptionLbl.text = filterOption
    }
    
    func reset() {
        checkBoxBtn.isSelected = false // Reset the button state
        updateCheckBoxImage(for: false) // Update the image
    }
    
    // Helper method to update the checkbox image
    func updateCheckBoxImage(for isSelected: Bool) {
        let imageName = isSelected ? "checkmark.circle.fill" : "checkmark.circle"
        checkBoxBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
