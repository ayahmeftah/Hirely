//
//  FlaggedJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class FlaggedJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var flaggedJob: UITableView!
    
    var flaggedJobs: [FlaggedJob] = [] // Store flagged job details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        flaggedJob.backgroundColor = .clear
        // Observer for job deletion or flag removal
           NotificationCenter.default.addObserver(self, selector: #selector(refreshFlaggedJobs), name: NSNotification.Name("JobDeleted"), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(refreshFlaggedJobs), name: NSNotification.Name("FlagRemoved"), object: nil)
        fetchFlaggedJobs()
    }
    
    @objc private func refreshFlaggedJobs(notification: NSNotification) {
        if let userInfo = notification.userInfo, let jobId = userInfo["jobId"] as? String {
            print("Refreshing flagged jobs after update for jobId: \(jobId)")
        }
        fetchFlaggedJobs()
    }

    
    private func setupTableView() {
        flaggedJob.backgroundColor = .clear
        let nib = UINib(nibName: "FlaggedJobsTableViewCell", bundle: nil)
        flaggedJob.register(nib, forCellReuseIdentifier: "customFlagged")
        flaggedJob.delegate = self
        flaggedJob.dataSource = self
    }
    
    private func fetchFlaggedJobs() {
        let db = Firestore.firestore()
        
        db.collection("flagDetails").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching flagged jobs: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No flagged jobs found.")
                return
            }
            
            // Use the initializer to create FlaggedJob instances
            self.flaggedJobs = documents.compactMap { document in
                return FlaggedJob(docId: document.documentID, data: document.data())
            }
            
            DispatchQueue.main.async {
                self.flaggedJob.reloadData()
            }
        }
    }

    
    private func fetchJobTitle(for jobId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("jobPostings").document(jobId).getDocument { document, error in
            if let error = error {
                print("Error fetching job title: \(error.localizedDescription)")
                completion("Unknown Title")
                return
            }
            
            if let document = document, document.exists,
               let jobTitle = document.data()?["jobTitle"] as? String {
                completion(jobTitle)
            } else {
                completion("Unknown Title")
            }
        }
    }
}

extension FlaggedJobsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flaggedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customFlagged", for: indexPath) as? FlaggedJobsTableViewCell else {
            return UITableViewCell()
        }
        
        let flaggedJob = flaggedJobs[indexPath.row]
        
        // Fetch the job title from the jobPostings collection
        fetchJobTitle(for: flaggedJob.jobId) { jobTitle in
            DispatchQueue.main.async {
                let companyName = "Google Inc"
                let companyImage = "google"
                cell.flaggedInit(companyName, companyImage, jobTitle, flaggedJob.status)
                cell.parentViewController = self
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flaggedJob = flaggedJobs[indexPath.row]
        performSegue(withIdentifier: "goToFlagInfo", sender: flaggedJob)
    }


    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let flaggedJob = flaggedJobs[indexPath.row]
//        performSegue(withIdentifier: "goToFlagInfo", sender: flaggedJob)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFlagInfo",
           let detailsVC = segue.destination as? FlagInfoTableViewController,
           let cell = sender as? FlaggedJobsTableViewCell,
           let indexPath = flaggedJob.indexPath(for: cell) {
            detailsVC.flagDetails = flaggedJobs[indexPath.row]
        }
    }



}
