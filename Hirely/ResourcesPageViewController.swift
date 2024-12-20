//
//  ResourcesPageViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit

class ResourcesPageViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoBtn?.setTitle("", for: .normal)
        careersBtn?.setTitle("", for: .normal)
        coursesBtn?.setTitle("", for: .normal)
        showImageButton?.setTitle("", for: .normal)

        videoBtn.adjustsImageWhenHighlighted = false
        showImageButton.addTarget(self, action: #selector(showImageButtonTapped), for: .touchUpInside)
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var videoBtn: UIButton!
    
    @IBOutlet weak var careersBtn: UIButton!
    
    @IBOutlet weak var coursesBtn: UIButton!
    @IBOutlet weak var showImageButton: UIButton!
//    @IBAction func showCoverLetter(_ sender: Any) {
//        // Check the index of the button in the table view (if applicable)
//           if let button = sender as? UIButton,
//              let cell = button.superview?.superview as? UITableViewCell,
//              let indexPath = tableView.indexPath(for: cell) {
//
//               print("Button tapped at row \(indexPath.row)") // Debugging log
//
//               // Present the image view controller
//               let imageVC = ImageViewController()
//               imageVC.modalPresentationStyle = .fullScreen
//               imageVC.imageName = "exampleImage" // Set your image name here
//
//               present(imageVC, animated: true, completion: nil)
//           }
//    }
    
    @objc func showImageButtonTapped() {
            // Initialize the ImageViewController
            let imageVC = ImageViewController()
            imageVC.modalPresentationStyle = .fullScreen
            imageVC.imageName = "cover" // Set the image name

            // Present the ImageViewController
            present(imageVC, animated: true, completion: nil)
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
