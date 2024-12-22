//
//  CareerTipsViewController.swift
//  Hirely
//
//  Created by  on 20/12/2024.
//

import UIKit
import SafariServices
import FirebaseFirestore
class CareerTipsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // Array to store articles
        var articles: [Article] = [
            Article(title: "5 Tips for a Successful Job Interview", url: URL(string: "https://ung.edu/career-services/online-career-resources/interview-well/tips-for-a-successful-interview.php")!),
            Article(title: "How to Build a Strong Resume", url: URL(string: "https://www.jobbank.gc.ca/findajob/resources/write-good-resume")!),
            Article(title: "Mastering Networking for Career Growth", url: URL(string: "https://www.linkedin.com/pulse/mastering-networking-career-business-growth-strategies-siivc")!)
        ]
    
    // TableView setup
           
    
    @IBOutlet weak var tableView: UITableView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    var isBookmarked = false
    
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Dequeue reusable cell
                    print("Dequeuing cell for row \(indexPath.row)") // Debug which row is being dequeued

                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? VideoTableViewCell else {
                        fatalError("Unable to dequeue VideoTableViewCell")
                    }
                    
                    // Configure cell with article data
                    let article = articles[indexPath.row]
                    cell.videoTitle.text = article.title // Set the title from the articles array
                    
                    // Disable cell selection (optional)
                    cell.selectionStyle = .default
            // Configure the cell
               
                // Configure the button
                cell.bookmarkBtn.isHidden = false
                cell.bookmarkBtn.alpha = 1.0
                cell.bookmarkBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)

               
            print("Bookmark button frame: \(cell.bookmarkBtn.frame)")
            print("Bookmark button isHidden: \(cell.bookmarkBtn.isHidden)")


                    
                    return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected article
        let article = articles[indexPath.row]
        
        // Show alert before opening the URL
        let alert = UIAlertController(
            title: "Open Article",
            message: "This will take you to an external link. Do you want to continue?",
            preferredStyle: .alert
        )
        
        // Add an action to open the link
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            self.openArticle(url: article.url)
        }
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
        
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func openArticle(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }


    }

       
       // MARK: - Helper Method to Open URL
       


struct Article {
    let title: String
    let url: URL
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // Structure to hold article data
   

