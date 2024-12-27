//
//  ApplicantAccountInfoTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 20/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ApplicantAccountInfoTableViewController: UITableViewController {
    
    
    var jobSeeker: JobSeeker? // Property to hold the passed job seeker
    @IBOutlet weak var applicantNameLbl: UILabel!
    
    @IBOutlet weak var applicantPhoneLbl: UILabel!
    
    @IBOutlet weak var applicantEmailLbl: UILabel!
    
    @IBOutlet weak var applicantAgeLbl: UILabel!
    
    @IBOutlet weak var applicantGenderLbl: UILabel!
    
    @IBOutlet weak var appliantCityLbl: UILabel!
    
    @IBOutlet weak var applicantStatusLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if a job seeker was passed and populate the UI
        if let jobSeeker = jobSeeker {
            print("Selected Job Seeker: \(jobSeeker.firstName) \(jobSeeker.lastName)")
            
            // Populate the labels with jobSeeker's details
            applicantNameLbl.text = "\(jobSeeker.firstName) \(jobSeeker.lastName)"
            applicantPhoneLbl.text = jobSeeker.phoneNumber
            applicantEmailLbl.text = jobSeeker.email
            applicantAgeLbl.text = jobSeeker.age != nil ? "\(jobSeeker.age!) years old" : "N/A"
            applicantGenderLbl.text = jobSeeker.gender
            appliantCityLbl.text = jobSeeker.city
            applicantStatusLbl.text = jobSeeker.status
        }
    }
    
    
    @IBAction func applicantDeleteAccountTapped(_ sender: UIButton) {
        
        
       //  Show a confirmation alert before deleting
              let alert = UIAlertController(
                  title: "Delete Account",
                 message: "Are you sure you want to delete this account? This action cannot be undone.",
                  preferredStyle: .alert
               )
       
              alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                   self.deleteAccount()
              }))
       
               present(alert, animated: true, completion: nil)
          }
           
        
        
    }
    
    
    
//    func applicantDeleteAccountTapped(_ sender: UIButton) {
//        
//        // Show a confirmation alert before deleting
//        let alert = UIAlertController(
//            title: "Delete Account",
//            message: "Are you sure you want to delete this account? This action cannot be undone.",
//            preferredStyle: .alert
//        )
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
//            self.deleteAccount()
//        }))
//        
//        present(alert, animated: true, completion: nil)
//    }
    
//}




func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


extension ApplicantAccountInfoTableViewController {
    
    func deleteAccount() {
        guard let jobSeeker = jobSeeker else {
            print("No job seeker found to delete.")
            return
        }

        let db = Firestore.firestore()

        // Step 1: Delete the document from Firestore
        db.collection("Users").document(jobSeeker.id).delete { error in
            if let error = error {
                print("Error deleting Firestore document: \(error.localizedDescription)")
                return
            }

            print("Firestore document deleted successfully.")

            DispatchQueue.main.async {
                // Step 2: Update the parent view controller's list
                if let parentVC = self.navigationController?.viewControllers.first(where: { $0 is ManageJobSeekersAccViewController }) as? ManageJobSeekersAccViewController {
                    // Remove the deleted job seeker from the array
                    if let index = parentVC.jobSeekersList.firstIndex(where: { $0.id == jobSeeker.id }) {
                        parentVC.jobSeekersList.remove(at: index)
                        parentVC.jobSeekers.reloadData() // Reload the table view immediately
                    }
                }

                // Step 3: Navigate back to the parent view controller
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


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


