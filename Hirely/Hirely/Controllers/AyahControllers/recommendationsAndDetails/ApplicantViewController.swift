//
//  ApplicantViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 14/12/2024.
//

import UIKit
import FirebaseFirestore

class ApplicantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()

    //Creating an Outlet for the recommended jobs table view
//    @IBOutlet weak var jobsTableView : UITableView!
    @IBOutlet weak var jobsCollectionView: UICollectionView!
    
    // User's answers
    var answerExperience = ""
    var softSkills: [String] = []
    var technicalSkills: [String] = []
    
    
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
        fetchFill()
        
        // Fetch jobs
        fetchRecommendedJobsFromFirestore()
    }
    
    func fetchFill(){
        let collection = db.collection("Users")
        
        collection.whereField("userId", isEqualTo: userId!).getDocuments { snapshot, error in
            if let error = error{
                print("Error getting document: \(error)")
                return
            }
            
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let data = doc.data()
                    
                    if let userId = data["userId"] as? String, userId == self.userId{
                        
                        if let softSkills = data["softSkills"] as? [String]{
                            self.softSkills = softSkills
                        }
                        
                        if let techSkills = data["technicalSkills"] as? [String]{
                            self.technicalSkills = techSkills
                        }
                        
                        if let experienceLevel = data["experienceLevel"] as? String{
                            self.answerExperience = experienceLevel
                        }
                    }
                }
            }
        }
    }
    
    func fetchRecommendedJobsFromFirestore() {
        
        
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
    var companies: [(name: String, imageName: String)] = [
        ("Google Inc", "google"),
        ("Microsoft", "microsoft"),
        ("AWS", "aws"),
        ("NBB Bank", "nbb")
    ]

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobPostings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedJob", for: indexPath) as! JobsCollectionViewCell
        let job = jobPostings[indexPath.row]
        
        // Pass job details to cell
        let company = companies[indexPath.row % companies.count]
        cell.postInit(company.name, job.jobType, job.jobTitle, company.imageName, job.postedDate, job.deadline, job.docId, false)
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust cell size (e.g., 90% of screen width and desired height)
        let width = collectionView.frame.width * 0.9
        let height: CGFloat = 200 // Adjust height as needed
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToJobDetails", sender: self)
    }
    
    func didTapViewDetails(for job: JobPosting) {
        // Trigger segue to details page with the selected job
        performSegue(withIdentifier: "goToJobDetails", sender: job)
    }
    
    // MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToJobDetails" {
            if let indexPath = jobsCollectionView.indexPathsForSelectedItems?.first,
               let destinationVC = segue.destination as? JobDetailsApplicantViewController {
                // Pass the selected job to the details page
                let selectedJob = jobPostings[indexPath.row]
                destinationVC.jobPosting = selectedJob
            }
        }
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
