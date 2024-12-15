//
//  ReportedJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class ReportedJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reportedJobs: UITableView!
    
    var companies = ["Microsoft Corporation", "Google LLC"]
    var jobs = ["Software Engineer", "Data Analyst"]
    let image = "google"

    override func viewDidLoad() {
        super.viewDidLoad()
        reportedJobs.backgroundColor = .clear

        let nib = UINib(nibName: "ReportedJobsTableViewCell", bundle: nil)
        reportedJobs.register(nib, forCellReuseIdentifier: "customReported")


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

extension ReportedJobsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customReported", for: indexPath) as? ReportedJobsTableViewCell
        
        cell?.reportediInit(companies[indexPath.row], jobs[indexPath.row], image)
        cell?.backgroundColor = .clear
        cell?.parentViewController = self //pass view controller to cell
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ReportedJobsTableViewCell,
           let _ = reportedJobs.indexPath(for: cell){
            if segue.identifier == "goToReportDetails"{
                if segue.destination is ReportedPostDetailsViewController{
                    //passing data
                }
            }
        }
    }
    
}
