//
//  ViewPostDeatilsAdminViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit

class ViewPostDeatilsAdminViewController: UIViewController {
    
    @IBOutlet weak var mainStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let skills = ["C++", "Azure Cloud Services", "Problem-solving","Python","critical thinking", "sql","AWS", "C#","Oracle", "web devlopment"]
        for skill in skills {
            addSkill(skill)
        }

        // Do any additional setup after loading the view.
    }
    func addSkill(_ skill: String) {
        // Create horizontal stack view
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 4 // Space between tick and label
        hStack.alignment = .center // Aligns tick and label vertically
        hStack.distribution = .fillProportionally
        
        // Create tick icon
        let tickImageView = UIImageView(image: UIImage(systemName: "checkmark.square.fill"))
        tickImageView.tintColor = .systemGreen
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true // Fixed size
        tickImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true // Fixed size
        tickImageView.contentMode = .scaleAspectFit // Proper image scaling
        
        // Create skill label
        let skillLabel = UILabel()
        skillLabel.text = skill
        skillLabel.font = UIFont.systemFont(ofSize: 16) // Adjust font size
        skillLabel.numberOfLines = 1 // Single line
        skillLabel.lineBreakMode = .byTruncatingTail // Handles long text
        skillLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to horizontal stack
        hStack.addArrangedSubview(tickImageView)
        hStack.addArrangedSubview(skillLabel)
        
        // Add horizontal stack to main vertical stack
        mainStack.addArrangedSubview(hStack)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
