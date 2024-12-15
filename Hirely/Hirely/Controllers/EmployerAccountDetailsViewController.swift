//
//  EmployerAccountDetailsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit

class EmployerAccountDetailsViewController: UIViewController {

    @IBOutlet weak var addPostingsBtn: UIButton!
    
    @IBOutlet weak var deletePostingsBtn: UIButton!
    
    @IBOutlet weak var editPostingsBtn: UIButton!
    
    
    @IBOutlet weak var selectActionBtn: UIButton!
    
    var isAddChecked = true
    var isDeleteChecked = true
    var isEditChecked = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update checkboxes to show initial checked state
        updateAddCheckbox()
        updateDeleteCheckbox()
        updateEditCheckbox()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editCheckboxTapped(_ sender: UIButton) {
        isEditChecked.toggle()
        updateEditCheckbox()
    }
    
    @IBAction func addCheckboxTapped(_ sender: UIButton) {
        isAddChecked.toggle()
        updateAddCheckbox()
    }
    
    @IBAction func deleteCheckboxTapped(_ sender: UIButton) {
        isDeleteChecked.toggle()
        updateDeleteCheckbox()
    }
    
    
    
    func updateAddCheckbox() {
        let imageName = isAddChecked ? "checkmark.square.fill" : "square"
        addPostingsBtn.setImage(UIImage(systemName: imageName), for: .normal)
        addPostingsBtn.tintColor = isAddChecked ? .systemGreen : .systemBlue // Green if checked, blue if uncheckede
        
    }
    
    func updateDeleteCheckbox() {
        let imageName = isDeleteChecked ? "checkmark.square.fill" : "square"
        
        deletePostingsBtn.setImage(UIImage(systemName: imageName), for: .normal)
        deletePostingsBtn.tintColor = isDeleteChecked ? .systemGreen : .systemBlue // Green if checked, blue if uncheckede
        
    }
    
    func updateEditCheckbox() {
        let imageName = isEditChecked ? "checkmark.square.fill" : "square"
        
        editPostingsBtn.setImage(UIImage(systemName: imageName), for: .normal)
        editPostingsBtn.tintColor = isEditChecked ? .systemGreen : .systemBlue // Green if checked, blue if uncheckede
        
    }

    @IBAction func actionSelection(_ sender: UIAction){
        print(sender.title)
        self.selectActionBtn.setTitle(sender.title, for: .normal)
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
