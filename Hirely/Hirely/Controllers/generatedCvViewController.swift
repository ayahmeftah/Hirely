//
//  GeneratedCVViewController.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import UIKit
import PDFKit

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

        // Display the CV content
        displayCV()
    }

    // MARK: - Display CV
    private func displayCV() {
        guard let cvData = cvData else {
            cvTextView.text = "Your CV is empty. Please provide details to generate your CV."
            return
        }

        var cvContent = ""

        // Add Personal Info
        if let personalInfo = cvData.personalInfo {
            cvContent += """
            Personal Information:
            Name: \(personalInfo.name)
            Email: \(personalInfo.email)
            Phone: \(personalInfo.phoneNumber)
            Summary: \(personalInfo.professionalSummary)
            
            """
        }

        // Add Skills
        if !cvData.skills.isEmpty {
            cvContent += "Skills:\n"
            cvContent += cvData.skills.map { $0.name }.joined(separator: ", ") + "\n\n"
        }

        // Add Experience
        if !cvData.experience.isEmpty {
            cvContent += "Experience:\n"
            for experience in cvData.experience {
                cvContent += """
                Title: \(experience.title)
                Company: \(experience.company)
                Duration: \(experience.duration)
                \n
                """
            }
        }

        // Add Education
        if !cvData.education.isEmpty {
            cvContent += "Education:\n"
            for education in cvData.education {
                cvContent += """
                Degree: \(education.degree)
                Institution: \(education.institution)
                Graduation Year: \(education.year)
                \n
                """
            }
        }

        // Add Certifications
        if !cvData.certifications.isEmpty {
            cvContent += "Certifications:\n"
            for certification in cvData.certifications {
                cvContent += "\(certification.name) - Issued Year: \(certification.year)\n"
            }
        }

        // Update the TextView
        cvTextView.text = cvContent.isEmpty ? "Your CV is empty. Please provide details to generate your CV." : cvContent
    }

    // MARK: - Actions
    @IBAction func shareCVButtonTapped(_ sender: UIButton) {
        generatePDF { pdfURL in
            guard let pdfURL = pdfURL else {
                self.showAlert(title: "Error", message: "Failed to generate the PDF. Please try again.")
                return
            }

            // Present the share sheet with the generated PDF
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
    }

    // MARK: - Generate PDF
    private func generatePDF(completion: (URL?) -> Void) {
        guard let cvData = cvData else {
            print("Error: CV data is nil.")
            completion(nil)
            return
        }

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // A4 size
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]

            var text = ""

            // Personal Info
            if let personalInfo = cvData.personalInfo {
                text += """
                Personal Information:
                Name: \(personalInfo.name)
                Email: \(personalInfo.email)
                Phone: \(personalInfo.phoneNumber)
                Summary: \(personalInfo.professionalSummary)
                
                """
            }

            // Skills
            if !cvData.skills.isEmpty {
                text += "Skills:\n\(cvData.skills.map { $0.name }.joined(separator: ", "))\n\n"
            }

            // Experience
            if !cvData.experience.isEmpty {
                text += "Experience:\n"
                for experience in cvData.experience {
                    text += "Title: \(experience.title), Company: \(experience.company), Duration: \(experience.duration)\n"
                }
                text += "\n"
            }

            // Education
            if !cvData.education.isEmpty {
                text += "Education:\n"
                for education in cvData.education {
                    text += "Degree: \(education.degree), Institution: \(education.institution), Graduation Year: \(education.year)\n"
                }
                text += "\n"
            }

            // Certifications
            if !cvData.certifications.isEmpty {
                text += "Certifications:\n"
                for certification in cvData.certifications {
                    text += "\(certification.name) - Issued Year: \(certification.year)\n"
                }
            }

            text.draw(in: CGRect(x: 20, y: 20, width: 572, height: 752), withAttributes: attributes)
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("CV.pdf")
        do {
            try pdfData.write(to: tempURL)
            completion(tempURL)
        } catch {
            print("Error generating PDF: \(error)")
            completion(nil)
        }
    }

    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

