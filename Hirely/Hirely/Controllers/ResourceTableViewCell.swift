//
//  ResourceTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var resiurceTitleLbl: ResourceTableViewCell!
    
    @IBOutlet weak var containerView: UIView!
    //    @IBOutlet weak var resourceTitle: UILabel!
//    @IBOutlet weak var resourceCatLbl: UILabel!
//    
//    @IBOutlet weak var resourceDeleteBtn: UIButton!
    
    @IBOutlet weak var resourceDeleteBtn: UIButton!
    @IBOutlet weak var resourceCatLbl: UILabel!
    
    @IBOutlet weak var resourceTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 20
       resourceDeleteBtn?.setTitle("", for: .normal)
        
        
        
       // containerView.layer.masksToBounds = true
        // Remove the title from the delete button
        //resourceDeleteBtn.setTitle("");
      //  resourceDeleteBtn.setTitle("", for: .highlighted) // Optional, ensures no text appears when tapped
      //  resourceDeleteBtn.setTitle("", for: .focused) // Optional, ensures no text when focused
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func update(with resource: Resource) {
        resourceTitle.text = resource.title
        resourceCatLbl.text = resource.category
        
    }
   

}
