//
//  ApplicantViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 14/12/2024.
//

import UIKit

class ApplicantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //Creating an Outlet for the recommended jobs table view
    @IBOutlet weak var jobsTableView : UITableView!
    
    var companies = ["Microsoft Corporation", "Google LLC"]
    var jobs = ["Software Engineer", "Data Analyst"]
    var jobTypes = ["Full-Time","Part-Time"]
    var imageName = ["microsoft","google"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobsTableView.backgroundColor = .clear


        let nib = UINib.init(nibName: "JobsTableViewCell", bundle: nil)
        jobsTableView.register(nib, forCellReuseIdentifier: "recommendedJob")
    }
    

}
extension ApplicantViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedJob", for: indexPath) as? JobsTableViewCell
        cell?.postInit(companies[indexPath.row], jobTypes[indexPath.row], jobs[indexPath.row], imageName[indexPath.row])
        cell?.backgroundColor = .clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(companies[indexPath.row])
    }
    
}
