//
//  ViewJobsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class ViewJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    @IBOutlet weak var jobPosts: UITableView!
    
    var companies = ["Microsoft Corporation", "Google LLC"]
    var jobs = ["Software Engineer", "Data Analyst"]
    var jobTypes = ["Full-Time","Part-Time"]
    var imageName = "google"

    override func viewDidLoad() {
        super.viewDidLoad()
        jobPosts.backgroundColor = .clear

        
        let nib = UINib.init(nibName: "ViewJobsAdminTableViewCell", bundle: nil)
        jobPosts.register(nib, forCellReuseIdentifier: "customJob")

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
extension ViewJobsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customJob", for: indexPath) as? ViewJobsAdminTableViewCell
        cell?.postInit(companies[indexPath.row], jobTypes[indexPath.row], jobs[indexPath.row], imageName)
        cell?.backgroundColor = .clear
        cell?.parentViewController = self //pass view controller to cell
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ViewJobsAdminTableViewCell,
           let _ = jobPosts.indexPath(for: cell){
            if segue.identifier == "goToJobDetails"{
                if segue.destination is ViewPostDeatilsAdminViewController{
                    //passing data
                }
            }else if segue.identifier == "goToFlagJob"{
                if segue.destination is FlagPostViewController{
                    //passing data
                }
            }
        }
    }
    
}
