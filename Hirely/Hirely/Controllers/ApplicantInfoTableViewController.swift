//
//  ApplicantInfoTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 18/12/2024.
//

import UIKit

class ApplicantInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var applicantName: UILabel!
    
    @IBOutlet weak var applicantAge: UILabel!
    
    @IBOutlet weak var applicantPhone: UILabel!
    
    @IBOutlet weak var applicantEmail: UILabel!
    
    @IBOutlet weak var viewCvBtn: UIButton!
    
    @IBOutlet weak var viewLetterBtn: UIButton!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var actionsMenuBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var isChecked = false

    @IBAction func checkboxTapped(_ sender: UIButton) {
        isChecked.toggle()
        updateCheckbox()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applicantName.text = "John Doe"
        applicantAge.text = "25"
        applicantPhone.text = "+123-456-7890"
        applicantEmail.text = "johndoe@email.com"

    }

        func updateCheckbox() {
            let imageName = isChecked ? "checkmark.square.fill" : "square"
            checkBoxBtn.setImage(UIImage(systemName: imageName), for: .normal)
            checkBoxBtn.tintColor = isChecked ? .systemGreen : .systemBlue // Green if checked, blue if unchecked

        }
    
    @IBAction func actionSelection(_ sender: UIAction){
        self.actionsMenuBtn.setTitle(sender.title, for: .normal)
    }
    
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem


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
