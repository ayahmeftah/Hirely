//
//  ApplicantViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 14/12/2024.
//

import UIKit
import FirebaseFirestore

class ApplicantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Creating an Outlet for the recommended jobs table view
//    @IBOutlet weak var jobsTableView : UITableView!
    @IBOutlet weak var jobsCollectionView: UICollectionView!
    
    // User's answers
    var answerExperience = "Associate"
    var softSkills = ["Teamwork", "Communication"]
    var technicalSkills = ["Swift", "Xcode","SQL"]
    
    // Array to hold JobPostings
    var jobPostings: [JobPosting] = []
    
//    var companies = ["Microsoft Corporation", "Google LLC"]
//    var jobs = ["Software Engineer", "Data Analyst"]
//    var jobTypes = ["Full-Time","Part-Time"]
//    var imageName = ["microsoft","google"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobsCollectionView.backgroundColor = .clear

        // Register custom collection view cell
        let nib = UINib(nibName: "JobsCollectionViewCell", bundle: nil)
        jobsCollectionView.register(nib, forCellWithReuseIdentifier: "recommendedJob")
        
        jobsCollectionView.delegate = self
        jobsCollectionView.dataSource = self
        
        // Set the layout for horizontal scrolling
        if let layout = jobsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        // Fetch jobs
        fetchRecommendedJobsFromFirestore()
    }
    
    func fetchRecommendedJobsFromFirestore() {
        let db = Firestore.firestore()
        
        // Fetch all jobs from Firestore
        db.collection("jobPostings")
            .whereField("isHidden", isEqualTo: false) // Exclude hidden jobs
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching jobs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                var rankedJobs: [(JobPosting, Int)] = [] // Tuple to hold jobs and their scores
                
                for document in documents {
                    let data = document.data()
                    let job = JobPosting(data: data)
                    
                    // Calculate match score
                    var matchScore = 0
                    
                    // Increase score for matching experience level
                    if job.experienceLevel == self.answerExperience {
                        matchScore += 3 // Higher weight for experience
                    }
                    
                    // Increase score for overlapping skills
                    let matchingSoftSkills = self.softSkills.filter { job.skills.contains($0) }
                    let matchingTechnicalSkills = self.technicalSkills.filter { job.skills.contains($0) }
                    matchScore += matchingSoftSkills.count + matchingTechnicalSkills.count
                    
                    // Add job to ranked list with its score
                    rankedJobs.append((job, matchScore))
                }
                
                // Sort jobs by score in descending order
                rankedJobs.sort { $0.1 > $1.1 }
                
                // Take at least 5 jobs (or fewer if less available)
                self.jobPostings = rankedJobs.prefix(5).map { $0.0 }
                
                // Reload collection view
                DispatchQueue.main.async {
                    self.jobsCollectionView.reloadData()
                }
            }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobPostings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedJob", for: indexPath) as! JobsCollectionViewCell
        let job = jobPostings[indexPath.row]
        
        // Pass job details to cell
        cell.postInit(job.jobTitle, job.jobType, job.city, "defaultImage")
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust cell size (e.g., 90% of screen width and desired height)
        let width = collectionView.frame.width * 0.9
        let height: CGFloat = 180 // Adjust height as needed
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Add spacing around the collection view
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Spacing between rows
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Spacing between items in the same row (if applicable)
        return 16
    }
    

}

//At Least 10 recommended Jobs - for FirstSearchViewController

//func fetchRecommendedJobsFromFirestore() {
//    let db = Firestore.firestore()
//    
//    // Fetch all jobs from Firestore
//    db.collection("jobPostings")
//        .whereField("isHidden", isEqualTo: false) // Exclude hidden jobs
//        .getDocuments { [weak self] (querySnapshot, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error fetching jobs: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else { return }
//            var rankedJobs: [(JobPosting, Int)] = [] // Tuple to hold jobs and their scores
//            
//            for document in documents {
//                let data = document.data()
//                let job = JobPosting(data: data)
//                
//                // Calculate match score
//                var matchScore = 0
//                
//                // Increase score for matching experience level
//                if job.experienceLevel == self.answerExperience {
//                    matchScore += 3 // Higher weight for experience
//                }
//                
//                // Increase score for overlapping skills
//                let matchingSoftSkills = self.softSkills.filter { job.skills.contains($0) }
//                let matchingTechnicalSkills = self.technicalSkills.filter { job.skills.contains($0) }
//                matchScore += matchingSoftSkills.count + matchingTechnicalSkills.count
//                
//                // Add job to ranked list with its score
//                rankedJobs.append((job, matchScore))
//            }
//            
//            // Sort jobs by score in descending order
//            rankedJobs.sort { $0.1 > $1.1 }
//            
//            // Take at least 10 jobs (or fewer if less available)
//            self.jobPostings = rankedJobs.prefix(10).map { $0.0 }
//            
//            // Reload collection view
//            DispatchQueue.main.async {
//                self.jobsCollectionView.reloadData()
//            }
//        }
//}
//
