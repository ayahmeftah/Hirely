//
//  EditSoftSkillViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 12/12/2024.
//

import UIKit

class EditSoftSkillViewController: UIViewController {
    
    @IBOutlet weak var addSkillBtn: UIButton!
    
    let addSoftSkillAlert = AddSoftSkillAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addSkillClicked(_ sender: UIButton) {
        let alertVC = addSoftSkillAlert.alert()
        present(alertVC, animated: true)
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
