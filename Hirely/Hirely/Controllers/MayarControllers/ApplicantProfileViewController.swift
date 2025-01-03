//
//  UserProfileViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit
import Cloudinary
import FirebaseFirestore
import FirebaseAuth

class ApplicantProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    let userId = currentUser().getCurrentUserId()
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    @IBOutlet weak var prefrencesSettingsTblView: UITableView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profilePicture: CLDUIImageView!
    
    
    var sections: [UserProfileSection]{
        let prefrencesOptions: [String] = ["Personal Information", "Soft & Technical Skills", "Applied Jobs", "Latest Resume"]
        
        let settingsOptions: [String] = ["Change Password", "About", "Application Guide", "Log Out"]
        
        let firstSection = UserProfileSection(sectionName: "User Prefrences", rows: prefrencesOptions)
        let secondSection = UserProfileSection(sectionName: "Settings", rows: settingsOptions)
        
        return [firstSection, secondSection]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        prefrencesSettingsTblView.reloadData()
        
        profilePicture.layer.cornerRadius = profilePicture.layer.frame.size.width / 2
        profilePicture.clipsToBounds = true
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
                        if let firstName = data["firstName"] as? String{
                            if let lastName = data["lastName"] as? String{
                                self.userName.text = "\(firstName) \(lastName)"
                            }
                        }
                        
                        if let email = data["email"] as? String{
                            self.userEmail.text = email
                        }
                        
                        if let profilePhotoLink = data["profilePhoto"] as? String{
                            self.profilePicture.cldSetImage(profilePhotoLink, cloudinary: self.cloudinary)
                        }
                    }
                }
            }
        }
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
}


extension ApplicantProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func configureTableView(){
        prefrencesSettingsTblView.delegate = self
        prefrencesSettingsTblView.dataSource = self
        fetchFill()
        //prefrencesSettingsTblView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Number of rows in section \(section): \(sections[section].rows.count)")
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        let section = sections[indexPath.section]
        let option = section.rows[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = option
        cell.accessoryType = .disclosureIndicator
        
        if option == "Log Out"{
            content.textProperties.color = .red
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return sections[0].sectionName
        case 1:
            return sections[1].sectionName
        default:
            return "Oops!"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35 // Increase the space above each section
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                performSegue(withIdentifier: "goToPersonalInfo", sender: nil)
            }
            else if indexPath.row == 1{
                performSegue(withIdentifier: "goToSkillsExperience", sender: nil)
            }
            else if indexPath.row == 2{
                performSegue(withIdentifier: "goToAppliedJobs", sender: nil)
            }
            else if indexPath.row == 3{
                performSegue(withIdentifier: "showCV", sender: nil)
            }
        }
        else if indexPath.section == 1{
            if indexPath.row == 0{
                performSegue(withIdentifier: "goToChangePassword", sender: nil)
            }
            else if indexPath.row == 1{
                performSegue(withIdentifier: "goToAbout", sender: nil)
            }
            else if indexPath.row == 2{
                performSegue(withIdentifier: "goToAppGuide", sender: nil)
            }
            else if indexPath.row == 3{
                showLogoutAlert()
            }
        }
    }
}
