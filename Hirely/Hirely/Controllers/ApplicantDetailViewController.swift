//
//  ApplicantDetailViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ApplicantDetailViewController: UIViewController {

    @IBOutlet weak var checkboxButton: UIButton!
    
    @IBOutlet weak var btn_select_action: UIButton!
    
    var isChecked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCheckbox()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        isChecked.toggle()
        updateCheckbox()
    }

    func updateCheckbox() {
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkboxButton.tintColor = isChecked ? .systemGreen : .systemBlue // Green if checked, blue if unchecked

    }
    
    @IBAction func actionSelection(_ sender: UIAction){
        self.btn_select_action.setTitle(sender.title, for: .normal)
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
