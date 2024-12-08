//
//  CVData.swift
//  Hirely
//
//  Created by BP-36-201-02 on 08/12/2024.
//

import Foundation

// MARK: - CVData Model
struct CVData {
    
    // MARK: - Nested Models
    struct PersonalInfo {
        var name: String
        var email: String
        var phoneNumber: String
        var  professionalSummary: String
    }
    
    struct Skill {
        var name: String
    }
    
    struct JobExperience {
        var title: String
        var company: String
        var duration: String
    }
    
    struct Education {
        var degree: String
        var institution: String
        var year: String
    }
    
    struct Certification {
        var name: String
        var year: String
    }
    
    // MARK: - Properties
    var personalInfo: PersonalInfo?
    var skills: [Skill] = []
    var experience: [JobExperience] = []
    var education: [Education] = []
    var certifications: [Certification] = []
    
    // MARK: - Methods
    /// Formats the CV data into a structured string
    func formattedCV() -> String {
        var result = ""
        
        // Personal Info
        if let info = personalInfo {
            result += """
            Personal Info:
            Name: \(info.name)
            Email: \(info.email)
            Phone: \(info.phoneNumber)
            professionalSummary: \(info.professionalSummary)
            
            """
        }
        
        // Skills
        if !skills.isEmpty {
            result += "Skills:\n"
            result += skills.map { $0.name }.joined(separator: ", ") + "\n\n"
        }
        
        // Experience
        if !experience.isEmpty {
            result += "Experience:\n"
            for job in experience {
                result += """
                Title: \(job.title)
                Company: \(job.company)
                Duration: \(job.duration)
                \n
                """
            }
        }
        
        // Education
        if !education.isEmpty {
            result += "Education:\n"
            for edu in education {
                result += """
                Degree: \(edu.degree)
                Institution: \(edu.institution)
                Year: \(edu.year)
                \n
                """
            }
        }
        
        // Certifications
        if !certifications.isEmpty {
            result += "Certifications:\n"
            for cert in certifications {
                result += "\(cert.name) - \(cert.year)\n"
            }
        }
        
        return result
    }
    
    /// Checks if all required fields are completed
    func isComplete() -> Bool {
        return personalInfo != nil &&
               !skills.isEmpty &&
               !experience.isEmpty &&
               !education.isEmpty &&
               !certifications.isEmpty
    }
}

