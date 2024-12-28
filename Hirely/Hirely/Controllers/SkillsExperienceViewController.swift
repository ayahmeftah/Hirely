//
//  SkillsExperienceViewController.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 10/12/2024.
//

import UIKit

class SkillsExperienceViewController: UIViewController{

    @IBOutlet weak var experienceTableView: UITableView!
    @IBOutlet weak var softSkillsTableView: UITableView!
    @IBOutlet weak var technicalSkillsTableView: UITableView!
    
    var experiences: [Experience] = []
    var softSkills: [String] = []
    var technicalSkills: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableViews()
    }
        
}

extension SkillsExperienceViewController: UITableViewDelegate, UITableViewDataSource{
    
    func configTableViews(){
        experienceTableView.tag = 1
        softSkillsTableView.tag = 2
        technicalSkillsTableView.tag = 3
        experienceTableView.delegate = self
        experienceTableView.dataSource = self
        softSkillsTableView.delegate = self
        softSkillsTableView.dataSource = self
        technicalSkillsTableView.delegate = self
        technicalSkillsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return 1
        }
        else if tableView.tag == 2 {
            return 1 // Number of sections for tableView2
        }
        else if tableView.tag == 3{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return experiences.count
        }
        else if tableView.tag == 2{
            return softSkills.count
        }
        
        else if tableView.tag == 3{
            return technicalSkills.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceTableViewCell
            //cell.configure(with: "Batelco", jobTitle: "Software Engineer", logo: UIImage(named: "batelco-logo"))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            if indexPath.section == 1 {
                let softSkills = ["Teamwork", "Communication", "Time Management", "Problem Solving", "Creativity"]
                cell.textLabel?.text = softSkills[indexPath.row]
            }
            else {
                let technicalSkills = ["Programming Languages", "Data Analysis and Data Science", "Web Development"]
                cell.textLabel?.text = technicalSkills[indexPath.row]
            }
            return cell
        }
    }
}
