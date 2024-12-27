//
//  InterviewDetailViewController.swift
//  Hirely
//
//  Created by BP-36-201-04 on 26/12/2024.
//

import UIKit
import FirebaseFirestore

class InterviewDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var interviewTableView: UITableView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var iconTitle: UILabel!
    
    @IBOutlet weak var info: UILabel!
    
    //initialize the data
    var icontitles = ["Date", "Time", "Locations", "Notes"]
    
    var interviewInfo: [String] = []
    
    
    
    
    //when it is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        interviewTableView.backgroundColor = .clear

        // Register the custom cell
        let nib = UINib(nibName: "InterviewInfoTableViewCell", bundle: nil)
        interviewTableView.register(nib, forCellReuseIdentifier: "interviewInfoTableViewCell")
        
        // Retrieve interview info from Firebase (see next section)
        fetchInterviewInfo()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icontitles.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "interviewInfoTableViewCell", for: indexPath) as? InterviewInfoTableViewCell else {
            return UITableViewCell()
        }
        
        // Configure the cell
            cell.titleLabel.text = icontitles[indexPath.row]
            cell.infoLabel.text = indexPath.row < interviewInfo.count ? interviewInfo[indexPath.row] : ""
        
        // Set the icon based on the title
            switch icontitles[indexPath.row] {
            case "Date":
                cell.iconImageView.image = UIImage(systemName: "calendar")
            case "Time":
                cell.iconImageView.image = UIImage(systemName: "clock")
            case "Locations":
                cell.iconImageView.image = UIImage(systemName: "mappin.and.ellipse")
            case "Notes":
                cell.iconImageView.image = UIImage(systemName: "note.text")
            default:
                cell.iconImageView.image = nil
            }
            
            return cell
    }
    
    
    

    func fetchInterviewInfo() {
        let db = Firestore.firestore()

        //replace "interviews" with the actual Firestore collection name
        db.collection("interviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching interview data: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            //clear any previous data
            self.interviewInfo.removeAll()

            for document in documents {
                let data = document.data()

                //handle each field
                let dateTimestamp = data["date"] as? Timestamp
                let timeTimestamp = data["time"] as? Timestamp
                let location = data["location"] as? String ?? "No Location"
                let notes = data["notes"] as? String ?? "No Notes"

                //unwrap the Timestamps and convert them to strings
                let date = dateTimestamp?.dateValue().formatted(date: .numeric, time: .omitted) ?? "No Date"
                let time = timeTimestamp?.dateValue().formatted(date: .omitted, time: .shortened) ?? "No Time"

                //append each piece of info to the array in the correct order
                self.interviewInfo.append(date)
                self.interviewInfo.append(time)
                self.interviewInfo.append(location)
                self.interviewInfo.append(notes)
            }

            // Reload the table view on the main thread
            DispatchQueue.main.async {
                self.interviewTableView.reloadData()
            }
        }
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
