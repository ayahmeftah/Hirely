//
//  ManageEmployersViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 08/12/2024.
//

import UIKit

class ManageEmployersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var employersTableView: UITableView!
    
    let employersNames = ["Sarah Lee", "John Smith"]
    
//    let status = ["Active","Suspended"]
    
    let pic = "man"
    

    let accountStatuses: [AccountStatus] = [.active, .suspended]


    override func viewDidLoad() {
        super.viewDidLoad()
        employersTableView.backgroundColor = .clear

        let nib = UINib.init(nibName: "ManageEmployersTableViewCell", bundle: nil)
        employersTableView.register(nib, forCellReuseIdentifier: "employer")

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
extension ManageEmployersViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employersNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employer", for: indexPath) as? ManageEmployersTableViewCell
        cell?.employersInit(employersNames[indexPath.row], pic)
        cell?.backgroundColor = .clear
        
        let status = accountStatuses[indexPath.row]

        cell?.configureBadge(for: status)
        cell?.parentViewController = self //pass view controller to cell
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ManageEmployersTableViewCell,
           let _ = employersTableView.indexPath(for: cell){
            if segue.identifier == "goToEmployerAccount"{
                if segue.destination is ManageEmployerTableViewController{
                    //passing data
                }
            }
        }
    }
}
