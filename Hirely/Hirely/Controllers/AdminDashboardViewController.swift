//
//  AdminDashboardViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 15/12/2024.
//

import UIKit
import FirebaseFirestore

class AdminDashboardViewController: UIViewController {
    

    @IBOutlet weak var totalEmployersLbl: UILabel!
    
    @IBOutlet weak var totalApplicantsLbl: UILabel!
    
    @IBOutlet weak var totalPostedJobsLbl: UILabel!
    
    @IBOutlet weak var totalFlaggedPostsLbl: UILabel!
    
    @IBOutlet weak var totalReportedPostsLbl: UILabel!
    
    private var jobPostingsListener: ListenerRegistration?
    private var flaggedPostsListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToTotalJobPostings()
        listenToTotalFlaggedPosts()
    }

    deinit {
        // remove the listeners to avoid consuming memory
        jobPostingsListener?.remove()
        flaggedPostsListener?.remove()
    }
    
    //listen to total job postings
        private func listenToTotalJobPostings() {
            let db = Firestore.firestore()
            //addSnapshotListener is a real time listener that updates data in real time
            jobPostingsListener = db.collection("jobPostings").addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to job postings: \(error.localizedDescription)")
                } else {
                    let totalJobPostings = snapshot?.documents.count ?? 0
                    DispatchQueue.main.async {
                        self.totalPostedJobsLbl.text = "Total job postings: \(totalJobPostings)"
                    }
                }
            }
        }

        //listen to total flagged posts
        private func listenToTotalFlaggedPosts() {
            let db = Firestore.firestore()
            
            flaggedPostsListener = db.collection("flagDetails").addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to flagged posts: \(error.localizedDescription)")
                } else {
                    let totalFlaggedPosts = snapshot?.documents.count ?? 0
                    DispatchQueue.main.async {
                        self.totalFlaggedPostsLbl.text = "Total flagged job postings: \(totalFlaggedPosts)"
                    }
                }
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
