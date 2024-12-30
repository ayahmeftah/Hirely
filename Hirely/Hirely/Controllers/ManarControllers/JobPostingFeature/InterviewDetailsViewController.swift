//
//  InterviewDetailsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 13/12/2024.
//

import UIKit

class InterviewDetailsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    // Static titles with dynamic values
    let interviewDetails: [(title: String, value: String)] = [
        ("Applicant Name", "John Doe"),
        ("Applied Position", "Software Engineer"),
        ("Interview Location", "Head Office"),
        ("Date", "2024/12/20"),
        ("Time", "10:00 AM"),
        ("Notes", "Bring relevant documents."),
        ("Applicant's Email", "johndoe@email.com"),
        ("Applicant's Phone", "+123456789")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
//        let numberOfRows = 8 // Fixed number of rows in your table
//        tableView.rowHeight = tableView.frame.height / CGFloat(numberOfRows)
//        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60 // Provide an estimated height
        tableView.tableFooterView = UIView()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interviewDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell with Subtitle style
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)
        
        // Assign the static title and value
        let detail = interviewDetails[indexPath.row]
        cell.textLabel?.text = detail.title  // Title text
        cell.detailTextLabel?.text = detail.value  // Subtitle text

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
