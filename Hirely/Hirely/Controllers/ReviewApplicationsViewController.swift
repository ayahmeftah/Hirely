//
//  ReviewApplicationsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit
import FirebaseFirestore


class ReviewApplicationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var applicantsTableView: UITableView!
    
    var jobId: String? // Passed from the job details screen
    var applications: [JobApplication] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applicantsTableView.backgroundColor = .clear
        
        // Register the nib for the custom cell
        let nib = UINib(nibName: "ApplicationsTableViewCell", bundle: nil)
        applicantsTableView.register(nib, forCellReuseIdentifier: "Applicant")
        
        applicantsTableView.delegate = self
        applicantsTableView.dataSource = self
        
        
        guard let jobId = jobId else { return }
        fetchApplications(for: jobId) { [weak self] fetchedApplications in
            self?.applications = fetchedApplications
            DispatchQueue.main.async {
                self?.applicantsTableView.reloadData()
            }
        }
        
        // Listen for status updates
            NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationStatusUpdate(_:)), name: NSNotification.Name("ApplicationStatusUpdated"), object: nil)

    }
    
    @objc private func handleApplicationStatusUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let docId = userInfo["docId"] as? String,
              let newStatus = userInfo["status"] as? String,
              let index = applications.firstIndex(where: { $0.docId == docId }) else { return }

        // Update the status locally
        applications[index].applicationStatus = newStatus

        // Reload the specific row in the table view
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.applicantsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func fetchApplications(for jobId: String, completion: @escaping ([JobApplication]) -> Void) {
        let db = Firestore.firestore()
        db.collection("appliedJobs").whereField("jobId", isEqualTo: jobId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching job applications: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents found for jobId: \(jobId)")
                completion([])
                return
            }
            let applications = documents.map { doc -> JobApplication in
                var data = doc.data()
                data["docId"] = doc.documentID
                print("Fetched application: \(data)") // Debug log
                return JobApplication(data: data)
            }
            completion(applications)
        }
    }

    
    
    // UITableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Applicant", for: indexPath) as? ApplicationsTableViewCell else {
            return UITableViewCell()
        }
        
        let application = applications[indexPath.row]
        cell.configure(with: application)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.parentViewController = self // Set reference for button actions
        
        // Set the closure to handle the button tap
            cell.viewButtonTapped = { [weak self] in
                self?.performSegue(withIdentifier: "goToApplicantDetails", sender: application)
            }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToApplicantDetails",
           let destinationVC = segue.destination as? ApplicantInfoTableViewController,
           let application = sender as? JobApplication {
            destinationVC.application = application
        }
    }




}
