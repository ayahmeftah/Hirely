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

        ]
    
    // TableView setup
           
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore() // Firestore reference
    @IBOutlet weak var backBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Fetch articles from Firestore
                fetchArticlesFromFirestore()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    var isBookmarked = false
    
    // Fetch resources with category "Articles" from Firestore
       private func fetchArticlesFromFirestore() {
           let db = Firestore.firestore()
           db.collection("Resources").whereField("resourceCategory", isEqualTo: "Articles").getDocuments { (snapshot, error) in
               if let error = error {
                   print("Error fetching articles: \(error.localizedDescription)")
               } else if let snapshot = snapshot {
                   // Map the Firestore documents to `Article` objects
                   self.articles = snapshot.documents.compactMap { doc in
                       guard let title = doc.data()["resourceTitle"] as? String,
                             let link = doc.data()["resourceLink"] as? String,
                             let url = URL(string: link) else {
                           return nil
                       }
                       return Article(title: title, url: url)
                   }

                   // Reload the table view to display the fetched data
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               }
           }
       }
    
    
    
    @IBAction func bookmarkTouched(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
           guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
               print("Error: Could not determine index path for bookmark.")
               return
           }

           // Retrieve the article associated with the bookmark button
           let article = articles[indexPath.row]

           // Toggle the bookmark state
           isBookmarked.toggle()

           // Update the button image and save/remove bookmark from Firestore
           if isBookmarked {
               (sender as AnyObject).setImage(UIImage(systemName: "bookmark.fill"), for: .normal) // Filled bookmark
               saveBookmarkToFirestore(article: article) // Save the article as a bookmark
           } else {
               (sender as AnyObject).setImage(UIImage(systemName: "bookmark"), for: .normal) // Unfilled bookmark
               removeBookmarkFromFirestore(article: article) // Remove the article from bookmarks
           }
            }

    
    
    // MARK: - Save Bookmark to Firestore
        private func saveBookmarkToFirestore(article: Article) {
            let bookmarksRef = db.collection("bookmarks").document("globalBookmarks").collection("savedResources")
            let articleData: [String: Any] = [
                "resourceTitle": article.title,
                "resourceLink": article.url.absoluteString,
                "resourceCategory": "Articles"
            ]

            bookmarksRef.addDocument(data: articleData) { error in
                if let error = error {
                    print("Error saving bookmark: \(error.localizedDescription)")
                } else {
                    print("Article bookmarked successfully.")
                }
            }
        }

        // MARK: - Remove Bookmark from Firestore
        private func removeBookmarkFromFirestore(article: Article) {
            let bookmarksRef = db.collection("bookmarks").document("globalBookmarks").collection("savedResources")

            bookmarksRef
                .whereField("resourceTitle", isEqualTo: article.title)
                .whereField("resourceLink", isEqualTo: article.url.absoluteString)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error finding bookmark to delete: \(error.localizedDescription)")
                    } else if let snapshot = snapshot {
                        for document in snapshot.documents {
                            document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting bookmark: \(error.localizedDescription)")
                                } else {
                                    print("Article unbookmarked successfully.")
                                }
                            }
                        }
                    }
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
   

