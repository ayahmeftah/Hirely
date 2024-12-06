//
//  AddJobPostingViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 06/12/2024.
//

import UIKit

class AddJobPostingViewController: UIViewController {

    @IBOutlet weak var btn_select_jobType: UIButton!
    
    @IBOutlet weak var btn_select_locationType: UIButton!
    
    @IBOutlet weak var btn_select_experience: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func jobTypeSelection(_ sender: UIAction){
        self.btn_select_jobType.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func locationTypeSelection(_ sender: UIAction){
        self.btn_select_locationType.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func experienceLevelSelection(_ sender: UIAction){
        self.btn_select_experience.setTitle(sender.title, for: .normal)
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
