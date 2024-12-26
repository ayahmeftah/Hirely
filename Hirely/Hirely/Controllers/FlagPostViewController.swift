//
//  FlagPostViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 15/12/2024.
//

import UIKit
import FirebaseFirestore

class FlagPostViewController: UIViewController {
    
    var jobId: String?
    var onSave: ((String, String) -> Void)? // Callback to pass data back to the parent view controller (viewJobsViewController)

    
    @IBOutlet weak var reasonTextField: UITextView!
    
    @IBOutlet weak var commentsTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveFlagDetails(_ sender: UIButton) {
        // Validate inputs
                guard let reason = reasonTextField.text, !reason.isEmpty,
                      let comments = commentsTextField.text, !comments.isEmpty else {
                    showAlert(title: "Error", message: "Please fill in all fields.")
                    return
        }
        
        // Pass data back using the callback
                onSave?(reason, comments)

                // Navigate back to the parent view controller
                navigationController?.popViewController(animated: true)
            }

            private func showAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true, completion: nil)
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
