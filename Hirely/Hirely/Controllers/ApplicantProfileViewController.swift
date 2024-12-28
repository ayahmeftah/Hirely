//
//  UserProfileViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit

class ApplicantProfileViewController: UIViewController {
    
    @IBOutlet weak var prefrencesSettingsTblView: UITableView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    var sections: [UserProfileSection]{
        let prefrencesOptions: [String] = ["Personal Information", "Skills and Experience", "Applied Jobs", "Bookmarks", "Resumes"]
        
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
}

extension ApplicantProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func configureTableView(){
        prefrencesSettingsTblView.delegate = self
        prefrencesSettingsTblView.dataSource = self
        userName.text = "Khalid Ali"
        userEmail.text = "khalidali@gmail.com"
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
            else if indexPath.row == 3{
                performSegue(withIdentifier: "goToBookmark", sender: nil)
            }
            else if indexPath.row == 4{
                performSegue(withIdentifier: "goToResumes", sender: nil)
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
                
            }
        }
    }
}
