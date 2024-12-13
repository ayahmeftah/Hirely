//
//  ScheduledInterviewsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ScheduledInterviewsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scheduledInterviewTableView: UITableView!
    // Sample data
       let applicantNames = ["Khalid Ali", "Sara Mohammed", "Ali Ahmed", "Layla Nasser", "Fatima Hussain"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "ScheduledInterviewsTableViewCell", bundle: nil)
        scheduledInterviewTableView.register(nib, forCellReuseIdentifier: "Interview")
        scheduledInterviewTableView.backgroundColor = .clear
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
extension ScheduledInterviewsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Interview", for: indexPath) as! ScheduledInterviewsTableViewCell
        cell.initializeInterview(applicantNames[indexPath.row])
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.parentViewController = self // Pass the view controller to the cell
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ScheduledInterviewsTableViewCell,
           let _ = scheduledInterviewTableView.indexPath(for: cell) {
            if segue.identifier == "goToInterviewDetails" {
                if segue.destination is InterviewDetailsViewController {
                    // Pass data for interview details
//                    destinationVC.interviewData = interviewData[indexPath.row]
                }
            } else if segue.identifier == "goToEditInterview" {
                if segue.destination is EditInterviewViewController {
                    // Pass data for editing the interview
//                    destinationVC.interviewData = interviewData[indexPath.row]
                }
            }
        }
    }

}
