//
//  GeneratedCVViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit
import PDFKit
import Cloudinary
import FirebaseFirestore

class generatedCvViewController: UIViewController {
    
    // MARK: - Properties
    var cvData: CVData? // Holds the collected CV data
    
    // MARK: - Outlets
    @IBOutlet weak var cvTextView: UITextView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging: Log CV data to ensure it's passed correctly
        print("Received CV Data: \(String(describing: cvData))")
        shareCVButton?.addTarget(self, action: #selector(shareCVButtonTapped(_:)), for: .touchUpInside)
        
        // Display the CV content
        displayCV()
        shareCVButton?.isEnabled = true
        CloudinarySetup.cloudinary = CloudinarySetup.cloudinarySetup()

    }
    
    private func displayCV() {
        guard let cvData = cvData else {
            cvTextView.text = "Your CV is empty. Please provide details to generate your CV."
            return
        }
        
        let cvContent = NSMutableAttributedString()
        
        // Add Personal Info
        if let personalInfo = cvData.personalInfo {
            cvContent.append(makeTitle("PERSONAL INFORMATION"))
            let personalInfoLine = """
               \(personalInfo.name) | \(personalInfo.email) | \(personalInfo.phoneNumber)
               """
            cvContent.append(makeBody("\(personalInfoLine)\n\n"))
            
            if !personalInfo.professionalSummary.isEmpty {
                cvContent.append(makeSubtitle("Professional Summary"))
                cvContent.append(makeBody("\(personalInfo.professionalSummary)\n\n"))
            }
            
            if !personalInfo.skills.isEmpty {
                cvContent.append(makeSubtitle("Skills"))
                let skillPoints = personalInfo.skills.split(separator: "\n").map { "• \($0)" }.joined(separator: "\n")
                cvContent.append(makeBody("\(skillPoints)\n\n"))
            }
        }
        
        // Add Experience
        if !cvData.experience.isEmpty {
            cvContent.append(makeTitle("PROFESSIONAL EXPERIENCE"))
            for experience in cvData.experience {
                cvContent.append(makeSubtitle(experience.title))
                cvContent.append(makeBody("""
                   Company: \(experience.company)
                   Duration: \(experience.duration)
                   Description: \(experience.description)
                   
                   """))
            }
        }
        
        // Add Education
        if !cvData.education.isEmpty {
            cvContent.append(makeTitle("EDUCATION"))
            for education in cvData.education {
                cvContent.append(makeSubtitle(education.degree))
                cvContent.append(makeBody("""
                   Institution: \(education.institution)
                   Graduation Year: \(education.year)
                   
                   """))
            }
        }
        
        // Add Certifications
        if !cvData.certifications.isEmpty {
            cvContent.append(makeTitle("CERTIFICATIONS"))
            for certification in cvData.certifications {
                cvContent.append(makeSubtitle(certification.name))
                cvContent.append(makeBody("Issued Year: \(certification.year)\n"))
            }
        }
        
        // Update the TextView with styled content
        cvTextView.attributedText = cvContent
        cvTextView.textAlignment = .left
    }
    
    private func makeTitle(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.systemBlue
        ]
        return NSAttributedString(string: "\(text)\n", attributes: attributes)
    }
    
    private func makeSubtitle(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: "\(text)\n", attributes: attributes)
    }
    
    private func makeBody(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.darkGray
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    @IBOutlet weak var shareCVButton: UIButton!
    // MARK: - Actions
    @IBAction func shareCVButtonTapped(_ sender: UIButton) {
        print("Button tapped!")
           let alertController = UIAlertController(
               title: "Export CV",
               message: "Your CV will be exported, saved to your files, and uploaded to the cloud. Do you want to continue?",
               preferredStyle: .alert
           )
           
           let exportAction = UIAlertAction(title: "Export & Upload CV", style: .default) { _ in
               self.generatePDF { pdfURL in
                   guard let pdfURL = pdfURL else {
                       self.showAlert(title: "Error", message: "Failed to generate the PDF. Please try again.")
                       return
                   }
                   
                   // Start Cloudinary upload
                   self.uploadCvToCloudinary(fileURL: pdfURL)
               }
           }
           
           let exitAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
               self.dismiss(animated: true, completion: nil)
           }
           
           alertController.addAction(exportAction)
           alertController.addAction(exitAction)
           
           self.present(alertController, animated: true, completion: nil)
       }

       private func uploadCvToCloudinary(fileURL: URL) {
           guard let cloudinary = CloudinarySetup.cloudinary else {
               self.showAlert(title: "Error", message: "Cloudinary is not configured properly.")
               return
           }

           let activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator.center = self.view.center
           self.view.addSubview(activityIndicator)
           activityIndicator.startAnimating()
           
           cloudinary.createUploader().upload(
               url: fileURL,
               uploadPreset: CloudinarySetup.uploadPreset,
               progress: { progress in
                   print("Upload progress: \(progress.fractionCompleted * 100)%")
               }
           ) { result, error in
               activityIndicator.stopAnimating()
               activityIndicator.removeFromSuperview()
               
               if let error = error {
                   print("Error uploading CV: \(error.localizedDescription)")
                   self.showAlert(title: "Error", message: "Failed to upload the CV. Please try again.")
               } else if let result = result, let secureUrl = result.secureUrl {
                   print("CV uploaded successfully.")
                   self.showAlert(title: "Success", message: "Your CV has been uploaded successfully.\nURL: \(secureUrl)")
                   self.saveCvUrlToFirestore(url: secureUrl)
               }
           }
       }

       private func saveCvUrlToFirestore(url: String) {
           let db = Firestore.firestore()
           let data: [String: Any] = [
               "cvUrl": url,
               "uploadedAt": Date()
           ]

           db.collection("CVs").addDocument(data: data) { error in
               if let error = error {
                   print("Error saving CV URL to Firestore: \(error.localizedDescription)")
                   self.showAlert(title: "Error", message: "Failed to save the CV URL to Firestore.")
               } else {
                   print("CV URL saved to Firestore successfully.")
               }
           }
    }
    
    private func generatePDF(completion: (URL?) -> Void) {
        guard let cvData = cvData else {
            completion(nil)
            return
        }
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
            
            var text = ""
            
            if let personalInfo = cvData.personalInfo {
                text += """
                   Name: \(personalInfo.name)
                   Email: \(personalInfo.email)
                   Phone: \(personalInfo.phoneNumber)
                   Professional Summary: \(personalInfo.professionalSummary)
                   Skills:
                   \(personalInfo.skills.split(separator: "\n").map { "• \($0)" }.joined(separator: "\n"))
                   
                   """
            }
            
            if !cvData.experience.isEmpty {
                text += "Experience:\n"
                for experience in cvData.experience {
                    text += """
                       Title: \(experience.title)
                       Company: \(experience.company)
                       Duration: \(experience.duration)
                       Description: \(experience.description)
                       
                       """
                }
            }
            
            if !cvData.education.isEmpty {
                text += "Education:\n"
                for education in cvData.education {
                    text += """
                       Degree: \(education.degree)
                       Institution: \(education.institution)
                       Graduation Year: \(education.year)
                       
                       """
                }
            }
            
            if !cvData.certifications.isEmpty {
                text += "Certifications:\n"
                for certification in cvData.certifications {
                    text += "\(certification.name) - \(certification.year)\n"
                }
            }
            
            text.draw(in: CGRect(x: 20, y: 20, width: 572, height: 752), withAttributes: attributes)
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("CV.pdf")
        do {
            try pdfData.write(to: tempURL)
            completion(tempURL)
        } catch {
            completion(nil)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    
    
    //cloud
    
    

    
    
}
