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
        }

        // Add Skills
        if !cvData.skills.isEmpty {
            cvContent.append(makeTitle("SKILLS"))
            let skills = cvData.skills.map { $0.name }.joined(separator: ", ")
            cvContent.append(makeBody("\(skills)\n\n"))
        }

        // Add Experience
        if !cvData.experience.isEmpty {
            cvContent.append(makeTitle("PROFESSIONAL EXPERIENCE"))
            for experience in cvData.experience {
                cvContent.append(makeSubtitle(experience.title))
                cvContent.append(makeBody("""
                Company: \(experience.company)
                Duration: \(experience.duration)

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

