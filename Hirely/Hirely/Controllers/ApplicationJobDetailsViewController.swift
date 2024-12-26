//
//  ApplicationJobDetailsViewController.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit

class ApplicationJobDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var jobPosition: String?
        var jobCompany: String?
        var jobStatus: String?
    
    @IBOutlet weak var jobDetailsTableView: UITableView!
    
    var titles = ["Job Type", "Experience Level", "Salary Range", "City", "Job Description", "Job Requirements", "Skills"]
    var information = ["Job Type", "Experience Level", "Salary Range", "City", "Job Description", "Job Requirements", "Skills"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobDetailsTableView.delegate = self
        jobDetailsTableView.dataSource = self

        // Set automatic dimensioning for multi-line cells
        jobDetailsTableView.estimatedRowHeight = 60
        jobDetailsTableView.rowHeight = UITableView.automaticDimension
        
        jobDetailsTableView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell with .subtitle style
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "jobDetailsAppliedTo")
        
        // Set the title and subtitle
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = indexPath.row < information.count ? information[indexPath.row] : "No Data"
        
        // Allow multi-line detail text
        cell.detailTextLabel?.numberOfLines = 0 // Unlimited lines
        
        // Customize appearance
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.textColor = .black
        cell.textLabel?.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 1.0) // Dark Blue
        cell.selectionStyle = .none
        
        return cell
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
