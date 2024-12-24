//
//  ViewApplicantCVViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 24/12/2024.
//

import UIKit
import FirebaseFirestore
import WebKit

class ViewApplicantCVViewController: UIViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadPDF()
    }

    //create and add the web view
    func setupWebView() {
        webView = WKWebView(frame: self.view.bounds) //creating a web view that covers whole page
        self.view.addSubview(webView)
    }

    //load the pdf link
    func loadPDF() {
        fetchPDFLink { [weak self] pdfLink in
            guard let self = self, let link = pdfLink, let url = URL(string: link) else {
                print("Failed to fetch or load PDF link.")
                return
            }
            DispatchQueue.main.async {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
        
        //fetch the pdf link from Firestore
        func fetchPDFLink(completion: @escaping (String?) -> Void) {
            let db = Firestore.firestore()
            let documentRef = db.collection("CVs").document("bvLwnPG1vRenTttTKBSJ")
            
            documentRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    completion(nil)
                    return
                }
                
                guard let document = document, document.exists, let pdfURL = document.data()?["cvUrl"] as? String else {
                    print("cvUrl field not found or document does not exist.")
                    completion(nil)
                    return
                }
                
                completion(pdfURL)
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
