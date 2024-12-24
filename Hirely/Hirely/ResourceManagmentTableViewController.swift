//
//  ResourceManagmentTableViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 10/12/2024.
//

import UIKit
import FirebaseFirestore
class ResourceManagmentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var resources: [Resource] = []
    var filteredResources: [Resource] = [] // For search results
    var documentIDs: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var resourceCatText: UILabel!
    
    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resourcecat: UILabel!
    
   @IBOutlet weak var titleText: UILabel!
    
    
    private func fetchResourcesFromFirestore() {
        let db = Firestore.firestore()
        db.collection("Resources").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching resources: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to fetch resources. Please try again.")
            } else if let snapshot = snapshot {
                self.resources.removeAll() // Clear the current array
                self.documentIDs.removeAll() // Clear the document IDs

                // Iterate over the documents
                for document in snapshot.documents {
                    let data = document.data()
                    
                    // Extract fields and validate
                    if let title = data["resourceTitle"] as? String,
                       let category = data["resourceCategory"] as? String,
                       let link = data["resourceLink"] as? String {
                        
                        // Create a Resource object
                        let resource = Resource(title: title, category: category, link: link)
                        self.resources.append(resource)
                        self.documentIDs.append(document.documentID)
                    } else {
                        print("Error: Missing or invalid fields in document: \(document.documentID)")
                    }
                }

                // Update filtered resources for search functionality
                self.filteredResources = self.resources

                // Reload the table view
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
          guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
              showAlert(title: "Error", message: "Unable to find the cell to delete.")
              return
          }
          deleteResource(at: indexPath) // Call the new method
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    // @IBOutlet weak var resoureTitleText: UILabel!
   // @IBOutlet weak var resourceCatText: UILabel!
    // @IBOutlet weak var resourceCatText: UILabel!
   // @IBOutlet weak var resoureTitleText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        resources = Resource.loadResources() ?? []
                  filteredResources = resources // Initially, show all resources
                  
                  // Setup Search Bar
                  setupSearchBar()
        fetchResourcesFromFirestore()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    private func setupSearchBar() {
            let searchBar = UISearchBar()
            searchBar.placeholder = "Search Resources"
            searchBar.delegate = self
            searchBar.sizeToFit() // Adjust size to fit content
            
            // Remove the default white background
            searchBar.backgroundImage = UIImage() // Removes the background
            searchBar.barTintColor = .clear // Make the bar background clear
            searchBar.isTranslucent = true // Make the search bar translucent
            
            // Customize the search text field to remove its background
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.backgroundColor = .clear // Make the text field background clear
                textField.textColor = .black // Set text color (adjust as needed)
            }
            
            // Attach the search bar to the table's header
            tableView.tableHeaderView = searchBar
        }
    

    // MARK: - Table view data source
    
    
    @IBAction func unwindToResourceTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEditResourceTableViewController,
              let resource = sourceViewController.resource else { return }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Editing an existing resource
            resources[selectedIndexPath.row] = resource
            filteredResources = resources // Update filtered resources
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // Adding a new resource
            let newIndexPath = IndexPath(row: resources.count, section: 0)
            resources.append(resource) // Update the data source
            filteredResources = resources // Update filtered resources
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }

        // Save the updated resources
        Resource.saveResources(resources)
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
        
        
    @IBAction func editButtonTapped(_ sender: Any) {
        // Determine the button's position within the table view
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
            guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
                showAlert(title: "Error", message: "Unable to find the cell to edit.")
                return
            }

            // Perform the segue programmatically
            let cell = tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "addEdirResource", sender: cell)
    }
    
        
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return filteredResources.count
            } else {
                return 0
            }
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //Step 1: Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceTableViewCell

            //Step 2: Fetch model object to display
            let resource = filteredResources[indexPath.row]

            //Step 3: Configure cell
            cell.update(with: resource)
            cell.showsReorderControl = true
        

            //Step 4: Return cell
            return cell
        }

       
    

        // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            let movedResource = resources.remove(at: fromIndexPath.row)
            resources.insert(movedResource, at: to.row)
        }
        
        
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
               deleteResource(at: indexPath) // Reuse the same method
           }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredResources = resources // Show all resources if search is cleared
        } else {
            filteredResources = resources.filter { resource in
                resource.title.lowercased().contains(searchText.lowercased()) ||
                resource.category.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder() // Dismiss the keyboard
        filteredResources = resources
        tableView.reloadData()
    }

        
        
        
        
    func deleteResource(at indexPath: IndexPath) {
        // Confirm Deletion Alert
        let alert = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete this resource?",
            preferredStyle: .alert
        )

        // Add "Delete" action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let documentIDToDelete = self.documentIDs[indexPath.row] // Fetch document ID
            
            // Delete from Firestore
            let db = Firestore.firestore()
            db.collection("Resources").document(documentIDToDelete).delete { error in
                if let error = error {
                    print("Error deleting resource: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to delete resource. Please try again.")
                } else {
                    print("Resource deleted successfully from Firestore.")
                    
                    // Update local data
                    self.resources.remove(at: indexPath.row)
                    self.filteredResources = self.resources
                    self.documentIDs.remove(at: indexPath.row)

                    // Update table view
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    self.showAlert(title: "Deleted", message: "Resource deleted successfully.")
                }
            }
        }))

        // Add "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the alert
        present(alert, animated: true, completion: nil)
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
