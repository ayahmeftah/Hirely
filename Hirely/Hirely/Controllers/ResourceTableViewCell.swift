//
//  ResourceTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var resiurceTitleLbl: ResourceTableViewCell!
    
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var resourceCatLbl: UILabel!
    
    @IBOutlet weak var resourceDeleteBtn: UIButton!
    
 
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(with resource: Resource) {
        resourceTitle.text = resource.title
        resourceCatLbl.text = resource.link
        
    }
   

}
