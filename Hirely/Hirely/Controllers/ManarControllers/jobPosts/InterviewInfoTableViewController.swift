import UIKit

class InterviewInfoTableViewController: UITableViewController {
    
    var titles = ["Interview Location", "Date", "Time", "Notes"]
    var info: [String] = [] // Store the interview information
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ensure info array has the same count as titles
        if info.count != titles.count {
            while info.count < titles.count {
                info.append("N/A") // Add placeholder data to avoid index out of range
            }
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        tableView.reloadData()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interviewCell", for: indexPath)
        
        // Safely access arrays
        if indexPath.row < titles.count {
            cell.textLabel?.text = titles[indexPath.row]
        } else {
            cell.textLabel?.text = "Unknown Title"
        }
        
        if indexPath.row < info.count {
            cell.detailTextLabel?.text = info[indexPath.row]
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        
        return cell
    }
}

