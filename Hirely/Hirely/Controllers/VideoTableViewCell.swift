//
//  VideoTableViewCell.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var videoTitle: UILabel!
    
    
    @IBOutlet weak var button: UIButton!
    
    
    @IBOutlet weak var containeView: VideoTableViewCell!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    func setup(title: String, link: URL){
        
        videoTitle.text = title
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        bookmarkBtn?.setTitle("", for: .normal)
        bookmarkBtn?.setTitle("", for: .highlighted)
        bookmarkBtn?.setTitle("", for: .selected)
        bookmarkBtn?.setTitle("", for: .disabled)
        // Make the view rounded
      
        
        
//        if containerView == nil {
//               print("containerView is nil! Check the storyboard connection.")
//           }
//           if videoTitle == nil {
//               print("videoTitle is nil! Check the storyboard connection.")
//           }
//           if button == nil {
//               print("registerBtn is nil! Check the storyboard connection.")
//           }
//           
//           // Add debugging colors
//           contentView.backgroundColor = .lightGray
//           containerView?.backgroundColor = .red
//           videoTitle?.backgroundColor = .yellow
//           button?.backgroundColor = .blue
        

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
