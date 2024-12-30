//
//  ViewApplicantCVViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 24/12/2024.
//

import UIKit
import WebKit

class ViewApplicantCVViewController: UIViewController {
    var webView: WKWebView!
    var cvLink: String? //store CV link passed from the previous view controller


    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadCV()
    }

    //create and add the web view
    func setupWebView() {
        webView = WKWebView(frame: self.view.bounds) //creating a web view that covers whole page
        self.view.addSubview(webView)
    }

    // Load the passed CV link
    func loadCV() {
        guard let cvLink = cvLink, let url = URL(string: cvLink) else {
            print("Invalid CV link or no CV link provided.")
            showErrorAlert()
            return
        }

        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }

    // Show an error alert if the CV link is invalid
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to load the CV. Please try again later.", preferredStyle: .alert)
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
