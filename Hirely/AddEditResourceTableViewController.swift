//
//  AddEditResourceTableViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit
import FirebaseFirestore

class AddEditResourceTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    
    var resource: Resource?
    var categories = ["Videos", "Articles", "Cover letter", "Courses"]

    
    @IBOutlet weak var resoureTitleText: UITextField!
    
    @IBOutlet weak var resourceCatlbl: UITextField!
    @IBOutlet weak var resourceLinkLbl: UITextField!

    @IBOutlet weak var savebtn: UIBarButtonItem!
    private let categoryPicker = UIPickerView()

    func updateSaveButtonState() {
        let titleText = resoureTitleText.text ?? ""
        let catText = resourceCatlbl.text ?? ""
        let linkText = resourceLinkLbl.text ?? ""
        savebtn.isEnabled =  !titleText.isEmpty && !catText.isEmpty && !linkText.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        if let resource = resource {
            resoureTitleText.text = resource.title
            resourceCatlbl.text = resource.category
            resourceLinkLbl.text = resource.link
           
            title = "Edit Resource"
        } else {
            title = "Add Resource"
        }
        
        
        // Set up category picker
                categoryPicker.delegate = self
                categoryPicker.dataSource = self
                resourceCatlbl.inputView = categoryPicker // Assign picker view as input for the text field
                resourceCatlbl.placeholder = "Select Category"

                // Add a toolbar with a Done button for the picker
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickingCategory))
                toolbar.setItems([doneButton], animated: true)
                toolbar.isUserInteractionEnabled = true
                resourceCatlbl.inputAccessoryView = toolbar
        updateSaveButtonState()
        
           resourceCatlbl.backgroundColor = .clear
           resourceCatlbl.borderStyle = .none
           resourceCatlbl.placeholder = "Select Category"
           resourceCatlbl.textAlignment = .left
           resourceCatlbl.font = UIFont.systemFont(ofSize: 16)
           
           
           resourceCatlbl.isUserInteractionEnabled = true


        
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // One column
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categories.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categories[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            resourceCatlbl.text = categories[row] // Update the text field with the selected category
        }
        
        @objc func donePickingCategory() {
            resourceCatlbl.resignFirstResponder() // Dismiss the picker view
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

        let title =  resoureTitleText.text ?? ""
        let cat = resourceCatlbl.text ?? ""
        let link = resourceLinkLbl.text ?? ""
        
        resource = Resource(title: title, category: cat, link: link)
        
        //database refrence
        let db = Firestore.firestore()
        
        let ResourcesCollection = db.collection("Resources")
        
        let newDofRef = ResourcesCollection.document()
        
        //Data to save
        let ResourcesData: [String: Any] = [
            "docId": newDofRef.documentID,
            "resourceTitle": title,
            "resourceCategory": cat,
            "resourceLink": link
        
        ]
        //saving the document
        newDofRef.setData(ResourcesData){ error in
            if let error = error {
                print("Error saving resources: \(error.localizedDescription)")
                
            }
            else{print("Resources saved successfully with docId:)\(newDofRef.documentID)")
                self.showSuccessAlert()}
            
        }
        
        
        
        // Show success alert
               showSuccessAlert()
    }
    func showSuccessAlert() {
           let alert = UIAlertController(title: "Success", message: "Resource added successfully!", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) { _ in
               self.navigationController?.popViewController(animated: true)
           }
           alert.addAction(okAction)
           present(alert, animated: true, completion: nil)
       }
    
    
    func saveResourcesToFireStore(){
   
        
    }
    
    // MARK: - Table view data sourc

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
