//
//  CoursesViewController.swift
//  Hirely
//
//  Created by on 19/12/2024.
//

import UIKit
import SafariServices


class CoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Course {
        let title: String
        let link: URL
    }

    
    var courses = [
            Course(title: "Accelerated Development Programme", link: URL(string: "https://www.london.edu/executive-education/general-management/accelerated-development-programme?utm_source=google&utm_medium=ppc&utm_campaign=MC_EEADP_ppc_google&utm_content=ppc&&ppc_keyword=management%20development%20course&gad_source=1&gclid=CjwKCAiAyJS7BhBiEiwAyS9uNWeerlmi_vjJharkzeR0gwRAjLEVMw0T2F0sKd4urCPzjEMSAifPgBoCTeUQAvD_BwE&gclsrc=aw.ds")!)
           
        ]
    // A flag to track the bookmark state
       var isBookmarked = false
    
    @IBOutlet weak var registerBtn: UIButton!
   // var course: Course? // Store the course for this cell




    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the table view's dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        

    }
    // Call this after the tableView is loaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        print("Touch detected at location: \(location)")
    }

    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func bookmarkTouched(_ sender: Any) {
        // Toggle the bookmark state
                isBookmarked.toggle()
                
                // Update the button image based on the state
                if isBookmarked {
                    (sender as AnyObject).setImage(UIImage(systemName: "bookmark.fill"), for: .normal) // Filled bookmark
                } else {
                    (sender as AnyObject).setImage(UIImage(systemName: "bookmark"), for: .normal) // Unfilled bookmark
                }
            }
    
    
    // MARK: - UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(courses.count)") // Debug the number of rows
        return courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Dequeue reusable cell
            print("Dequeuing cell for row \(indexPath.row)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as? VideoTableViewCell else {
                fatalError("Unable to dequeue CourseCell")
            }
            
            // Configure cell with course data
            let course = courses[indexPath.row]
            cell.videoTitle.text = course.title
            cell.selectionStyle = .default // Make the cell clickable
            
            return cell
        }


   
    
    // MARK: - UITableView Delegate
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Get the selected course
            let course = courses[indexPath.row]
            
            // Show alert before opening the URL
            showAlertBeforeOpening(url: course.link)
            
            // Deselect the cell after tapping
            tableView.deselectRow(at: indexPath, animated: true)
        }

    // MARK: - Show Alert Before Opening Link
       func showAlertBeforeOpening(url: URL) {
           let alert = UIAlertController(
               title: "Open Course",
               message: "This will take you to an external link. Do you want to continue?",
               preferredStyle: .alert
           )
           
           // Open Course Action
           let openAction = UIAlertAction(title: "Open Link", style: .default) { _ in
               self.openCourseInApp(url: url)
           }
           
           // Cancel Action
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           // Add actions to the alert
           alert.addAction(openAction)
           alert.addAction(cancelAction)
           
           // Present the alert
           present(alert, animated: true, completion: nil)
       }
       
       // MARK: - Open Link in SafariViewController
       func openCourseInApp(url: URL) {
           let safariVC = SFSafariViewController(url: url)
           safariVC.modalPresentationStyle = .fullScreen
           present(safariVC, animated: true, completion: nil)
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



