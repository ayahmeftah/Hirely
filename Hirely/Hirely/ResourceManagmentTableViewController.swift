//
//  ResourceManagmentTableViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit

class ResourceManagmentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var resources: [Resource]=[Resource(title: "hpw to prepare for an interview", category: "video", link: "uhfuhuhfguhrfuhruh")]
    
    @IBOutlet weak var resoureTitleText: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var resourceCatText: UILabel!
    
    
    
    
    
    
    
    // @IBOutlet weak var resoureTitleText: UILabel!
   // @IBOutlet weak var resourceCatText: UILabel!
    // @IBOutlet weak var resourceCatText: UILabel!
   // @IBOutlet weak var resoureTitleText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source
    
    
    @IBAction func unwindToResourceTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditResourceTableViewController,
            let resource = sourceViewController.resource else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            resources[selectedIndexPath.row] = resource
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: resources.count, section: 0)
            resources.append(resource)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    
    

    @IBSegueAction func addEdirResource(_ coder: NSCoder, sender: Any?) -> AddEditResourceTableViewController? {
        if let cell = sender as? UITableViewCell, let indexpath = tableView.indexPath(for: cell) {
            // Editing resource
            let resourceToEdit = resources[indexpath.row]
            return AddEditResourceTableViewController(coder: coder, resource: resourceToEdit)
        } else {
            // Adding resource
            return AddEditResourceTableViewController(coder: coder, resource: nil)
        }
    }
        
        
        
        
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return resources.count
            } else {
                return 0
            }
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //Step 1: Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceTableViewCell

            //Step 2: Fetch model object to display
            let resource = resources[indexPath.row]

            //Step 3: Configure cell
            cell.update(with: resource)
            cell.showsReorderControl = true

            //Step 4: Return cell
            return cell
        }

        // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                resources.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }

        // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            let movedResource = resources.remove(at: fromIndexPath.row)
            resources.insert(movedResource, at: to.row)
        }
        
        
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //    }
        //    override func numberOfSections(in tableView: UITableView) -> Int {
        //        // #warning Incomplete implementation, return the number of sections
        //        return 0
        //    }
        //
        //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        // #warning Incomplete implementation, return the number of rows
        //        return 0
        //    }
        
    
}
