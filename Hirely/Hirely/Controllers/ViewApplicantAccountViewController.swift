//
//  ViewApplicantAccountViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 15/12/2024.
//

import UIKit

class ViewApplicantAccountViewController: UIViewController {
    
    
    @IBOutlet weak var actionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectAction(_ sender: UIAction){
        print(sender.title)
        self.actionBtn.setTitle(sender.title, for: .normal)
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
