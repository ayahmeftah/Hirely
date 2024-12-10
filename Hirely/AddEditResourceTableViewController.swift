//
//  AddEditResourceTableViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit

class AddEditResourceTableViewController: UITableViewController {

    
    var resource: Resource?
    
    @IBOutlet weak var resourceTitlelbl: UITextField!
    
    @IBOutlet weak var resourceCatlbl: UITextField!
    @IBOutlet weak var resourceLinkLbl: UITextField!
    
    @IBOutlet weak var savebtn: UIBarButtonItem!
    
    func updateSaveButtonState() {
        let titleText = resourceTitlelbl.text ?? ""
        let catText = resourceCatlbl.text ?? ""
        let linkText = resourceLinkLbl.text ?? ""
        savebtn.isEnabled =  !titleText.isEmpty && !catText.isEmpty && !linkText.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        if let resource = resource {
            resourceTitlelbl.text = resource.title
            resourceCatlbl.text = resource.category
            resourceLinkLbl.text = resource.link
           
            title = "Edit Resource"
        } else {
            title = "Add Resource"
        }
        
        
        
        updateSaveButtonState()
        
        
        
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }

    init?(coder: NSCoder, resource: Resource?) {
        self.resource = resource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }

        let title =  resourceTitlelbl.text ?? ""
        let cat = resourceCatlbl.text ?? ""
        let link = resourceLinkLbl.text ?? ""
        
        resource = Resource(title: title, category: cat, link: link)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
