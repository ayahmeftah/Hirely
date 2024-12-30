//
//  ReportedJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit
import FirebaseFirestore

class ReportedJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reportedJobs: UITableView!
    
    var reportedJobPostings: [JobPosting] = []

    
    override func viewDidLoad() {
           super.viewDidLoad()
           reportedJobs.backgroundColor = .clear

           let nib = UINib(nibName: "ReportedJobsTableViewCell", bundle: nil)
           reportedJobs.register(nib, forCellReuseIdentifier: "customReported")
           fetchJobs()
       }
       
       // Fetch reported jobs from Firestore
       func fetchReportedJobs(completion: @escaping ([JobPosting]) -> Void) {
           let db = Firestore.firestore()
           db.collection("jobPostings").whereField("isReported", isEqualTo: true).getDocuments { snapshot, error in
               if let error = error {
                   print("Error fetching reported jobs: \(error.localizedDescription)")
                   completion([])
                   return
               }
               guard let documents = snapshot?.documents else {
                   completion([])
                   return
               }

               let jobs = documents.compactMap { document -> JobPosting? in
                   var data = document.data()
                   data["docId"] = document.documentID // Include docId explicitly
                   return JobPosting(data: data)
               }
               completion(jobs)
           }
       }
       
       private func fetchJobs() {
           fetchReportedJobs { [weak self] jobs in
               self?.reportedJobPostings = jobs
               DispatchQueue.main.async {
                   self?.reportedJobs.reloadData()
               }
           }
       }

       // Dismiss a job and update the Firestore database
    private func dismissJob(_ job: JobPosting, at indexPath: IndexPath) {
        let db = Firestore.firestore()
        db.collection("jobPostings").document(job.docId).updateData(["isReported": false]) { [weak self] error in
            if let error = error {
                print("Error dismissing job: \(error.localizedDescription)")
            } else {
                print("Job dismissed.")
                self?.reportedJobPostings.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self?.reportedJobs.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }


       // Navigate to the detailed report screen
       private func viewJobDetails(_ job: JobPosting) {
           performSegue(withIdentifier: "goToReportDetails", sender: job)
       }

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "goToReportDetails",
                  let cell = sender as? ReportedJobsTableViewCell,
                  let indexPath = reportedJobs.indexPath(for: cell),
                  let detailsVC = segue.destination as? ReportedPostDetailTableViewController {
                   detailsVC.job = reportedJobPostings[indexPath.row] // Pass job details
               }
           }

       // MARK: - Table View Delegate and DataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return reportedJobPostings.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "customReported", for: indexPath) as? ReportedJobsTableViewCell else {
                   return UITableViewCell()
               }
               
               let job = reportedJobPostings[indexPath.row]
               
               //Set up the cell
               cell.reportediInit("Google LLC", job.jobTitle, "google") //change later
               cell.parentViewController = self //Set the parent view controller
               cell.dismissAction = { [weak self] in
                   self?.dismissJob(job, at: indexPath) //Handle dismiss action
               }
           cell.backgroundColor = .clear
               return cell
           }
   }
