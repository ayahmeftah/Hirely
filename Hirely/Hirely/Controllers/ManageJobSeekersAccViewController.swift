//
//  ManageJobSeekersAccViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 09/12/2024.
//

import UIKit

class ManageJobSeekersAccViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var jobSeekers: UITableView!

    let seekerNames = ["Khalid Ali", "Layla Nasser"]
    let pic = "man"
    
    let accountStatuses: [AccountStatus] = [.active, .deleted]

    override func viewDidLoad() {
        super.viewDidLoad()
        jobSeekers.backgroundColor = .clear

        let nib = UINib.init(nibName: "ManageJobSeekersAccTableViewCell", bundle: nil)
        jobSeekers.register(nib, forCellReuseIdentifier: "customJobSeeker")

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
extension ManageJobSeekersAccViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seekerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customJobSeeker", for: indexPath) as? ManageJobSeekersAccTableViewCell
        cell?.seekersInit(seekerNames[indexPath.row], pic)
        cell?.backgroundColor = .clear
        
        let status = accountStatuses[indexPath.row]

        cell?.configureBadge(for: status)
        cell?.parentViewController = self //pass view controller to cell

        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ManageJobSeekersAccTableViewCell,
           let _ = jobSeekers.indexPath(for: cell){
            if segue.identifier == "goToApplicantDetails"{
                if segue.destination is ApplicantAccountInfoTableViewController{
                    //passing data
                }
            }
        }
    }
}
