//
//  ManageEmployerTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 20/12/2024.
//

import UIKit

class ManageEmployerTableViewController: UITableViewController {
    
    
    @IBOutlet weak var employerNameLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var employerEmaiLbl: UILabel!
    
    @IBOutlet weak var employerGenderLbl: UILabel!
    
    @IBOutlet weak var employerPhoneLbl: UILabel!
    
    @IBOutlet weak var employerAgeLbl: UILabel!
    
    @IBOutlet weak var employerCityLbl: UILabel!
    
    @IBOutlet weak var employerAccountStatusLbl: UILabel!
    
    @IBOutlet weak var totalJobs: UILabel!

    @IBOutlet weak var addPostingsBtn: UIButton!
    
    @IBOutlet weak var editPostingsBtn: UIButton!
    
    @IBOutlet weak var deletePostingsBtn: UIButton!
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
