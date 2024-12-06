//
//  JobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class JobPostingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var companies = ["Microsoft Corporation", "Google LLC", "Apple Inc."]
    var jobTypes = ["Full-Time", "Part-Time", "Contract"]
    var jobTitles = ["Software Engineer", "Data Analyst", "Product Manager"]
    
    var companyImages = ["microsoft","apple", "google"]
//    var hideIcon = "hideIcon"
//    var editIcon = "editIcon"
//    var delIcon = "deleteIcon"


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        

        
        let nib = UINib.init(nibName: "CustomJobPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "jobCustomCell")

        // Do any additional setup after loading the view.
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

extension JobPostingViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "jobCustomCell", for: indexPath) as? CustomJobPostTableViewCell
        cell?.commonInit(companies[indexPath.row], companyImages[indexPath.row], jobTitles[indexPath.row], jobTypes[indexPath.row])
        cell?.backgroundColor = .clear
        cell?.contentView.backgroundColor = .clear

        return cell!
    }


    
}
