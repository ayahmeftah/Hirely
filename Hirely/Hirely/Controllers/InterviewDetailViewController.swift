//
//  InterviewDetailViewController.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit

class InterviewDetailViewController: UIViewController {

    @IBOutlet weak var interviewTableView: UITableView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var iconTitle: UILabel!
    
    @IBOutlet weak var info: UILabel!
    
    var icontitles = ["Date", "Time", "Locations", "Notes"]
    
    
    var interviewInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interviewTableView.backgroundColor = .clear

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
