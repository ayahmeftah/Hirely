//
//  FlaggedJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class FlaggedJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var flaggedJob: UITableView!
    
    var companies = ["Microsoft Corporation", "Google LLC","Amazon"]
    var jobs = ["Software Engineer", "Data Analyst","Cloud Architect"]
    var image = "google"
    
    let flagStatuses: [FlagState] = [.deleted, .flagged, .edited]


    override func viewDidLoad() {
        super.viewDidLoad()
        flaggedJob.backgroundColor = .clear

        let nib = UINib(nibName: "FlaggedJobsTableViewCell", bundle: nil)
        flaggedJob.register(nib, forCellReuseIdentifier: "customFlagged")

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

extension FlaggedJobsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customFlagged", for: indexPath) as? FlaggedJobsTableViewCell
        
        cell?.flaggedInit(companies[indexPath.row], image, jobs[indexPath.row])
        cell?.backgroundColor = .clear
        
        let status = flagStatuses[indexPath.row]

        cell?.configureBadge(for: status)
        
        cell?.parentViewController = self //pass view controller to cell

        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? FlaggedJobsTableViewCell,
           let _ = flaggedJob.indexPath(for: cell){
            if segue.identifier == "goToFlagInfo"{
                if segue.destination is FlagInfoTableViewController{
                    //passing data
                }
            }
        }
    }
}
