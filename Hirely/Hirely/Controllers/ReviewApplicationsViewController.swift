//
//  ReviewApplicationsViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 07/12/2024.
//

import UIKit

class ReviewApplicationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var applicantsTableView: UITableView!
    
    // Sample data
       let applicantNames = ["Khalid Ali", "Sara Mohammed", "Ali Ahmed", "Layla Nasser", "Fatima Hussain"]
       let applicationStatus = ["Rejected", "Hired", "New", "Scheduled Interview", "Reviewed"]
       
       override func viewDidLoad() {
           super.viewDidLoad()
           applicantsTableView.backgroundColor = .clear

           
           // Register the nib for the custom cell
           let nib = UINib(nibName: "ApplicationsTableViewCell", bundle: nil)
           applicantsTableView.register(nib, forCellReuseIdentifier: "Applicant")
           
           applicantsTableView.delegate = self
           applicantsTableView.dataSource = self
       }
       
       // UITableView DataSource Methods
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return applicantNames.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "Applicant", for: indexPath) as? ApplicationsTableViewCell else {
               return UITableViewCell()
           }
           
           // Pass the applicant name and status to the cell
           cell.applicantsInit(applicantNames[indexPath.row], applicationStatus[indexPath.row])
           cell.backgroundColor = .clear
           cell.contentView.backgroundColor = .clear
           return cell
       }
   }
