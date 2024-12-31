//
//  ManageEmployerTableViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 20/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ManageEmployerTableViewController: UITableViewController {
    
    
    @IBOutlet weak var employerNameLbl: UILabel!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
    @IBOutlet weak var employerEmaiLbl: UILabel!
    
    @IBOutlet weak var employerGenderLbl: UILabel!
    
    @IBOutlet weak var employerPhoneLbl: UILabel!
    
    @IBOutlet weak var employerAgeLbl: UILabel!
    
    @IBOutlet weak var employerCityLbl: UILabel!
    
    @IBOutlet weak var employerAccountStatusLbl: UILabel!
        
    var employer: Employer? //store passed employer details


    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if an employer was passed and populate the UI
               if let employer = employer {
                   print("Selected employer: \(employer.firstName) \(employer.lastName)")
                   
                   // Populate the labels with employer's details
                   employerNameLbl.text = "\(employer.firstName) \(employer.lastName)"
                   employerPhoneLbl.text = employer.phoneNumber
                   employerEmaiLbl.text = employer.email
                   employerAgeLbl.text = employer.age != nil ? "\(employer.age!) years old" : "N/A"
                   employerGenderLbl.text = employer.gender
                   employerCityLbl.text = employer.city
                   employerAccountStatusLbl.text = employer.status
               }
           }
    
    
    @IBAction func employerDeleteTapped(_ sender: UIButton) {
        
            //Show a confirmation alert before deleting
                   let alert = UIAlertController(
                       title: "Delete Account",
                      message: "Are you sure you want to delete this account?",
                       preferredStyle: .alert
                    )
            
                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        self.deleteAccount()
                   }))
            
                    present(alert, animated: true, completion: nil)
               }
      
         
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

extension ManageEmployerTableViewController {
    
    func deleteAccount() {
            guard let employer = employer else {
                print("No employer found to delete.")
                return
            }

            let db = Firestore.firestore()
            let user = Auth.auth().currentUser

            let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                //Delete the document from Firestore
                db.collection("Users").document(employer.id).delete { error in
                    if let error = error {
                        print("Error deleting Firestore document: \(error.localizedDescription)")
                        return
                    }

                    print("Firestore document deleted successfully.")

                    //Delete the user from Firebase Authentication
                    user?.delete { authError in
                        if let authError = authError {
                            print("Error deleting Firebase Authentication user: \(authError.localizedDescription)")
                            return
                        }

                        print("Firebase Authentication user deleted successfully.")

                        DispatchQueue.main.async {
                            // Update the parent view controller's list
                            if let parentVC = self.navigationController?.viewControllers.first(where: { $0 is ManageEmployersViewController }) as? ManageEmployersViewController {
                                // Remove the deleted job seeker from the array
                                if let index = parentVC.employersList.firstIndex(where: { $0.id == employer.id }) {
                                    parentVC.employersList.remove(at: index)
                                    parentVC.employersTableView.reloadData() // Reload the table view immediately
                                }
                            }

                            //Navigate back to the parent view controller
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }
