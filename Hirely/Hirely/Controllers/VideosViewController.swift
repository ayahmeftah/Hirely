//
//  VideosViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit
import SafariServices
import FirebaseFirestore

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
  
    // A flag to track the bookmark state
       var isBookmarked = false
    
    // Array to hold video data
    var videos: [Video] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension

        // Fetch videos from Firestore
                fetchVideosFromFirestore()
        
        
//        arrVideos.append(Video.init(title: "Video", link: //<#T##URL#>))
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Fetch Videos from Firestore
        private func fetchVideosFromFirestore() {
            let db = Firestore.firestore()
            db.collection("Resources").whereField("resourceCategory", isEqualTo: "Videos").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching videos: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    // Map Firestore documents to Video objects
                    self.videos = snapshot.documents.compactMap { doc in
                        guard let title = doc.data()["resourceTitle"] as? String,
                              let linkString = doc.data()["resourceLink"] as? String,
                              let url = URL(string: linkString) else {
                            return nil
                        }
                        return Video(title: title, link: url)
                    }

                    // Reload table view to display fetched data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    
    
    
    
    
    
    
    
    
    @IBAction func bookmarkTouched(_ sender: Any) {
        // Get the index path of the button in the table view
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: tableView)
               guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
                   print("Error: Could not determine the index path.")
                   return
               }

               // Retrieve the video associated with the bookmark button
               let video = videos[indexPath.row]

               // Toggle the bookmark state
               isBookmarked.toggle()

               // Update the button image based on the bookmark state
               if isBookmarked {
                   (sender as AnyObject).setImage(UIImage(systemName: "bookmark.fill"), for: .normal) // Filled bookmark
                   saveBookmarkToFirestore(video: video) // Save the video as a bookmark
               } else {
                   (sender as AnyObject).setImage(UIImage(systemName: "bookmark"), for: .normal) // Unfilled bookmark
                   removeBookmarkFromFirestore(video: video) // Remove the video from bookmarks
               }
            }
    

    @IBAction func openVideo(_ sender: Any) {
        // Ensure the button's tag corresponds to the index of the video
        // Use guard to safely unwrap the tag property
        guard let videoIndex = (sender as AnyObject).tag as Int?, videoIndex < videos.count else {
            return // Exit if tag is invalid or out of bounds
        }

        // Retrieve the video using the index
        let video = videos[videoIndex]
        
        // Open the video URL
        if UIApplication.shared.canOpenURL(video.link) {
            UIApplication.shared.open(video.link, options: [:], completionHandler: nil)
        } else {
            // Show error if URL can't be opened
            let alert = UIAlertController(title: "Error", message: "Unable to open YouTube video.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "VidoeCell", for: indexPath) as? VideoTableViewCell else {
                    fatalError("Unable to dequeue VideoTableViewCell")
                }
                
                // Configure cell with video data
                let video = videos[indexPath.row]
                cell.videoTitle.text = video.title
                
                return cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected video
        let video = videos[indexPath.row]
        
        // Show confirmation alert before opening the video
        showAlertBeforeOpening(url: video.link)
        
        // Deselect the row after tap
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Show Alert Before Opening Video
    func showAlertBeforeOpening(url: URL) {
        let alert = UIAlertController(
            title: "Open Video",
            message: "This will take you to YouTube outside the app. Do you want to continue?",
            preferredStyle: .alert
        )
        
        // Open Video Action
        let openAction = UIAlertAction(title: "Open Video", style: .default) { _ in
            self.openVideoInApp(url: url)
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Open Video in SFSafariViewController
    func openVideoInApp(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        self.present(safariVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160 // Replace with the desired height
    }

    // MARK: - Save Bookmark to Firestore
        private func saveBookmarkToFirestore(video: Video) {
            let db = Firestore.firestore()
            let bookmarksRef = db.collection("bookmarks").document("globalBookmarks").collection("savedResources")

            let videoData: [String: Any] = [
                "resourceTitle": video.title,
                "resourceLink": video.link.absoluteString,
                "resourceCategory": "Videos" // Explicitly define the category
            ]

            bookmarksRef.addDocument(data: videoData) { error in
                if let error = error {
                    print("Error saving bookmark: \(error.localizedDescription)")
                } else {
                    print("Video bookmarked successfully.")
                }
            }
        }

        // MARK: - Remove Bookmark from Firestore
        private func removeBookmarkFromFirestore(video: Video) {
            let db = Firestore.firestore()
            let bookmarksRef = db.collection("bookmarks").document("globalBookmarks").collection("savedResources")

            // Query the Firestore database for the video
            bookmarksRef
                .whereField("resourceTitle", isEqualTo: video.title)
                .whereField("resourceLink", isEqualTo: video.link.absoluteString)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error finding bookmark to delete: \(error.localizedDescription)")
                    } else if let snapshot = snapshot {
                        // Delete the matching documents
                        for document in snapshot.documents {
                            document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting bookmark: \(error.localizedDescription)")
                                } else {
                                    print("Video unbookmarked successfully.")
                                }
                            }
                        }
                    }
                }
        }

    struct Video{
        
        
        let title : String
        let link : URL
        
        
    }
    
    
    
}
