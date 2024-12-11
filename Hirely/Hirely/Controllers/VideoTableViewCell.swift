//
//  VideoTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var videoTitle: UILabel!
    
    
    
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    func setup(title: String, link: URL){
        
        videoTitle.text = title
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
