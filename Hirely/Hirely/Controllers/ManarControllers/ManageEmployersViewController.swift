//
//  ManageEmployersViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit
import FirebaseFirestore


class ManageEmployersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var employersTableView: UITableView!
    
        
    let pic = "man"
    var employersList: [Employer] = [] //Array to hold employers fetched from Firestore

    override func viewDidLoad() {
        super.viewDidLoad()
        employersTableView.backgroundColor = .clear

        let nib = UINib.init(nibName: "ManageEmployersTableViewCell", bundle: nil)
        employersTableView.register(nib, forCellReuseIdentifier: "employer")
        fetchActiveEmployers()
    }
    
    func fetchActiveEmployers() {
        let db = Firestore.firestore()

        db.collection("Users")
            .whereField("isEmployer", isEqualTo: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching employers: \(error)")
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No matching documents found.")
                    return
                }

                print("Fetched \(documents.count) employers.")

                self.employersList = documents.compactMap { document -> Employer? in
                    let data = document.data()

                    let dobTimestamp = data["dateOfBirth"] as? Timestamp
                    let dateOfBirth = dobTimestamp?.dateValue()

                    return Employer(
                        id: document.documentID,
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        profilePhoto: data["profilePhoto"] as? String ?? "",
                        status: data["status"] as? String ?? "Active",
                        dateOfBirth: dateOfBirth,
                        phoneNumber: data["phoneNumber"] as? String ?? "N/A",
                        email: data["email"] as? String ?? "N/A",
                        gender: data["gender"] as? String ?? "N/A",
                        city: data["city"] as? String ?? "N/A"
                    )
                }

                DispatchQueue.main.async {
                                self.employersTableView.reloadData() // Refresh the table view
                            }
            }
    }


}
extension ManageEmployersViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employer", for: indexPath) as? ManageEmployersTableViewCell
        
        let employer = employersList[indexPath.row]
        cell?.employersInit(employer.fullName, employer.profilePhoto)
        cell?.configureBadge(for: .active) // All fetched users should be active
        cell?.parentViewController = self // Pass parent view controller
        
        cell?.backgroundColor = .clear
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ManageEmployersTableViewCell,
           let indexPath = employersTableView.indexPath(for: cell) {
            if segue.identifier == "goToEmployerAccount",
               let destinationVC = segue.destination as? ManageEmployerTableViewController {
                destinationVC.employer = employersList[indexPath.row]
            }
        }
    }
}
