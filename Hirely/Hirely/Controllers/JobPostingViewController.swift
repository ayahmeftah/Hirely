//
//  JobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit
import FirebaseFirestore

class JobPostingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!

    var jobPostings: [JobPosting] = [] // Array to store job postings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        let nib = UINib.init(nibName: "CustomJobPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "jobCustomCell")
        fetchJobPostings() // Fetch data from Firestore

        // Do any additional setup after loading the view.
    }
    // MARK: - Fetch Data from Firestore
    func fetchJobPostings() {
        let db = Firestore.firestore()
        db.collection("jobPostings").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching job postings: \(error.localizedDescription)")
            } else {
                self.jobPostings.removeAll() // Clear existing data
                
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let jobPosting = JobPosting(data: data) // Convert document to JobPosting
                    self.jobPostings.append(jobPosting)
                }
                // Reload the table view with new data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    }

extension JobPostingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobPostings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jobCustomCell", for: indexPath) as? CustomJobPostTableViewCell else {
            return UITableViewCell()
        }
        
        let job = jobPostings[indexPath.row]
                
                // Use commonInit to configure the cell
                cell.commonInit(
                    "Microsoft Corporation",        // Company name
                    "microsoft",    // Placeholder image name
                    job.jobTitle,          // Job title
                    job.jobType,           // Job type
                    "Posted: \(job.postedDate)", // Posted date
                    "Deadline: \(job.deadline)", // Deadline
                    "Applicants: 0"        // Placeholder for applicants count
                )
                cell.backgroundColor = .clear
                cell.contentView.backgroundColor = .clear
        cell.parentViewController = self // Pass the view controller to the cell
                return cell
    }
    // Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CustomJobPostTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let selectedJob = jobPostings[indexPath.row] // Get the selected job posting
            
            if segue.identifier == "goToDetails" {
                if let detailsVC = segue.destination as? JobDetailsViewController {
                    detailsVC.jobPosting = selectedJob // Pass the selected job
                }
            } else if segue.identifier == "goToApplicants" {
                if let applicantsVC = segue.destination as? ReviewApplicationsViewController {
//                    applicantsVC.jobPosting = selectedJob // Pass the selected job
                }
            } else if segue.identifier == "editJobDetails" {
                if let editVC = segue.destination as? EditJobPostViewController {
//                    editVC.jobPosting = selectedJob // Pass the selected job
                }
            }
        }
    }

}
