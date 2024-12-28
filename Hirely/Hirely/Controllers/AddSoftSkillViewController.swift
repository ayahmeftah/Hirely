//
//  AddSoftSkillViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 12/12/2024.
//

import UIKit

class AddSoftSkillViewController: UIViewController {
    
    @IBOutlet weak var skillTextField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskPath = UIBezierPath(roundedRect: self.contentView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 30, height: 30))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        self.contentView.layer.mask = shapeLayer
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
