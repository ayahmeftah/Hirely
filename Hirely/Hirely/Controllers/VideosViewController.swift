//
//  VideosViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit
import SafariServices

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
  
    // A flag to track the bookmark state
       var isBookmarked = false
    
    // Array to hold video data
    var arrVideos = [
        Video(title: "Introduction to Swift", link: URL(string: "https://www.youtube.com/watch?v=FcsY1YPBwzQ")!),
        Video(title: "iOS Development Basics", link: URL(string: "https://www.youtube.com/watch?v=B3P3OtadHRk")!)
    ]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension

        
//        arrVideos.append(Video.init(title: "Video", link: //<#T##URL#>))
        
        
        
        // Do any additional setup after loading the view.
    }
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
    

    @IBAction func openVideo(_ sender: Any) {
        // Ensure the button's tag corresponds to the index of the video
        // Use guard to safely unwrap the tag property
        guard let videoIndex = (sender as AnyObject).tag as Int?, videoIndex < arrVideos.count else {
            return // Exit if tag is invalid or out of bounds
        }

        // Retrieve the video using the index
        let video = arrVideos[videoIndex]
        
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
        return arrVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "VidoeCell", for: indexPath) as? VideoTableViewCell else {
                    fatalError("Unable to dequeue VideoTableViewCell")
                }
                
                // Configure cell with video data
                let video = arrVideos[indexPath.row]
                cell.videoTitle.text = video.title
                
                return cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected video
        let video = arrVideos[indexPath.row]
        
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

    
    struct Video{
        
        
        let title : String
        let link : URL
        
        
    }
    
    
    
}
