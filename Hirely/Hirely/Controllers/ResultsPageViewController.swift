//
//  ResultsPageViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 24/12/2024.
//

import UIKit
import FirebaseFirestore

class ResultsPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    @IBOutlet weak var jobResultsTableView: UITableView!
    
    
    let filters = ["Job Type", "Experience Level", "Location Type", "Salary Range"]
    
    var jobs: [JobPosting] = [] // Array to hold job postings
    var searchQuery: String = "" // Query passed from the previous screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FiltersCollectionViewCell", bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: "FilterCell")
        
        // Set delegate and data source for collection view
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        // Enable automatic dimension
        jobResultsTableView.rowHeight = UITableView.automaticDimension
        jobResultsTableView.estimatedRowHeight = 100 // Set an estimated height
        // TableView setup
        jobResultsTableView.backgroundColor = .clear
        let nib2 = UINib.init(nibName: "JobsResultTableViewCell", bundle: nil)
        jobResultsTableView.register(nib2, forCellReuseIdentifier: "jobResultCell")
        jobResultsTableView.delegate = self
        jobResultsTableView.dataSource = self
        
        // Fetch job postings from Firestore
        fetchJobPostings()
        
    }
    
    func fetchJobPostings() {
        let db = Firestore.firestore()
        
        // Query Firestore for job postings matching the search query
        db.collection("jobPostings")
            .whereField("jobTitle", isGreaterThanOrEqualTo: searchQuery)
            .whereField("jobTitle", isLessThanOrEqualTo: searchQuery + "\u{f8ff}")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching job postings: \(error)")
                    return
                }
                
                self.jobs = snapshot?.documents.compactMap { document in
                    JobPosting(data: document.data()) // Map Firestore document to JobPosting model
                } ?? []
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.jobResultsTableView.reloadData()
                }
            }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FiltersCollectionViewCell
        cell.postInit(filters[indexPath.item]) // Set label text
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
       /* cell.contentView.backgroundColor = .gray*/ // Update background color
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dynamically calculate the label's width based on its content
        let labelWidth = filters[indexPath.item].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
        let cellHeight: CGFloat = 40 // Fixed height for the cell
        return CGSize(width: labelWidth + 40, height: cellHeight) // Add padding to the width
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = filters[indexPath.item]
        print("Selected Filter: \(selectedFilter)")
    }
    
    // TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jobResultCell", for: indexPath) as? JobsResultTableViewCell else {
            return UITableViewCell()
        }
        
        let job = jobs[indexPath.row]
        /*cell.resultiInit(job.companyName, job.jobTitle, "placeholder_image", job.jobType)*/ // Replace "placeholder_image" with real image loading logic
        // Use commonInit to configure the cell
        cell.resultiInit(
            "microsoft",
            job.jobTitle,
            "Microsoft company",
            job.jobType
        )
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = jobs[indexPath.row]
        print("Selected Job: \(job.jobTitle)")
        // Navigate to a detailed job posting view if needed
    }
    
    
}
