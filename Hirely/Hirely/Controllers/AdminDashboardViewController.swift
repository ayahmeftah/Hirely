//
//  AdminDashboardViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 15/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AdminDashboardViewController: UIViewController {
    

    @IBOutlet weak var totalEmployersLbl: UILabel!
    
    @IBOutlet weak var totalApplicantsLbl: UILabel!
    
    @IBOutlet weak var totalPostedJobsLbl: UILabel!
    
    @IBOutlet weak var totalFlaggedPostsLbl: UILabel!
    
    @IBOutlet weak var totalReportedPostsLbl: UILabel!
    
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
 
    private var jobPostingsListener: ListenerRegistration?
    private var flaggedPostsListener: ListenerRegistration?
    private var reportedPostsListener: ListenerRegistration?
    private var usersListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToTotalJobPostings()
        listenToTotalFlaggedPosts()
        listenToTotalReportedPosts()
        listenToTotalUsers()

    }


    deinit {
        // remove the listeners to avoid consuming memory
        jobPostingsListener?.remove()
        flaggedPostsListener?.remove()
        reportedPostsListener?.remove()
        usersListener?.remove()
    }
    
    func showErrorAlert(_ errorMessage: String){
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Call this function when you want to show the logout confirmation alert
    func showLogoutAlert() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        // Create the "Yes" action
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            // Handle the log out action
            self.logOut()
        }
        
        // Create the "No" action
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            // Handle the cancel action (do nothing)
            print("User canceled log out.")
        }
        
        // Add actions to the alert controller
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logOut(){
        let auth = Auth.auth()
        do{
            try auth.signOut()
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            self.dismiss(animated: true)
        }catch let signOutError{
            showErrorAlert("\(signOutError)")
        }
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
    
    // Listen to total reported posts
       private func listenToTotalReportedPosts() {
           let db = Firestore.firestore()
           reportedPostsListener = db.collection("jobPostings").whereField("isReported", isEqualTo: true).addSnapshotListener { snapshot, error in
               if let error = error {
                   print("Error listening to reported posts: \(error.localizedDescription)")
               } else {
                   let totalReportedPosts = snapshot?.documents.count ?? 0
                   DispatchQueue.main.async {
                       self.totalReportedPostsLbl.text = "Total reported job postings: \(totalReportedPosts)"
                   }
               }
           }
       }
    
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        showLogoutAlert()
    }
    
       // Listen to total users (employers and applicants)
       private func listenToTotalUsers() {
           let db = Firestore.firestore()
           usersListener = db.collection("Users").addSnapshotListener { snapshot, error in
               if let error = error {
                   print("Error listening to users: \(error.localizedDescription)")
               } else {
                   let documents = snapshot?.documents ?? []
                   let totalEmployers = documents.filter { $0.data()["isEmployer"] as? Bool == true }.count
                   let totalApplicants = documents.filter { $0.data()["isApplicant"] as? Bool == true }.count
                   
                   DispatchQueue.main.async {
                       self.totalEmployersLbl.text = "- Employers: \(totalEmployers)"
                       self.totalApplicantsLbl.text = "- Job Seekers: \(totalApplicants)"
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
