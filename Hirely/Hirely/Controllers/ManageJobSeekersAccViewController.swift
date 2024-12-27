//
//  ManageJobSeekersAccViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.

import UIKit
import FirebaseFirestore



class ManageJobSeekersAccViewController: UIViewController{

    @IBOutlet weak var jobSeekers: UITableView!

    var jobSeekersList: [JobSeeker] = [] // Array to hold job seekers fetched from Firestore

       override func viewDidLoad() {
           super.viewDidLoad()
           jobSeekers.backgroundColor = .clear

           let nib = UINib.init(nibName: "ManageJobSeekersAccTableViewCell", bundle: nil)
           jobSeekers.register(nib, forCellReuseIdentifier: "customJobSeeker")

           jobSeekers.delegate = self
           jobSeekers.dataSource = self

           fetchActiveJobSeekers() // Fetch data from Firestore
       }

    func fetchActiveJobSeekers() {
        let db = Firestore.firestore()

        db.collection("Users")
            .whereField("isApplicant", isEqualTo: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching job seekers: \(error)")
                    return
                }

                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No matching documents found.")
                    return
                }

                print("Fetched \(documents.count) job seekers.")

                self.jobSeekersList = documents.compactMap { document -> JobSeeker? in
                    let data = document.data()

                    let dobTimestamp = data["dateOfBirth"] as? Timestamp
                    let dateOfBirth = dobTimestamp?.dateValue()

                    return JobSeeker(
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
                                self.jobSeekers.reloadData() // Refresh the table view
                            }
            }
    }



   }

   // MARK: - UITableViewDelegate and UITableViewDataSource
   extension ManageJobSeekersAccViewController: UITableViewDelegate, UITableViewDataSource {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return jobSeekersList.count // Use jobSeekersList for the row count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "customJobSeeker", for: indexPath) as! ManageJobSeekersAccTableViewCell

           let seeker = jobSeekersList[indexPath.row]
           cell.seekersInit(seeker.fullName, seeker.profilePhoto) // Use fullName and profilePhoto
           cell.configureBadge(for: .active) // All fetched users should be active
           cell.parentViewController = self // Pass parent view controller

           return cell
       }

       
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let cell = sender as? ManageJobSeekersAccTableViewCell,
              let indexPath = jobSeekers.indexPath(for: cell) {
               if segue.identifier == "goToApplicantDetails",
                  let destinationVC = segue.destination as? ApplicantAccountInfoTableViewController {
                   destinationVC.jobSeeker = jobSeekersList[indexPath.row]
               }
           }
       }


}
