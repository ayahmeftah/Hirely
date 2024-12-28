//
//  Applicant.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 25/12/2024.
//

import Foundation
import FirebaseCore

class Applicant{
    var docId: String
    var userid: String
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: String
    var phoneNumber: String
    var city: String
    var profilePhoto: String
    var interests: [String]
    var expertise: [String]
    var experienceLevel: String
    var expectedMinimumSalary: Int
    var expectedMaximumSalary: Int
    var softSkills: [String]
    var technicalSkills: [String]
    var experience: [String] //array of experience ids
    var appliedJobs: [String] //array of applied jobs ids
    var jobsBookmark: [String] //array of job ids
    var resourcesBookmark: [String] //array of resource ids
    var cvs: [String] //array of CV ids
    var isApplicant: Bool
    var isAdmin: Bool
    var isEmployer: Bool
    
    init(data: [String: Any]){
        self.docId = data["docId"] as? String ?? ""
        self.userid = data["userId"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.password = data["password"] as? String ?? ""
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
        self.gender = data["gender"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? "No phone number added"
        self.city = data["city"] as? String ?? "Not chosen"
        self.profilePhoto = data["profilePhoto"] as? String ?? "Not available"
        self.interests = data["interests"] as? [String] ?? []
        self.expertise = data["expertise"] as? [String] ?? []
        self.experienceLevel = data["experienceLevel"] as? String ?? "No experience level chosen"
        self.expectedMinimumSalary = data["minimumExpectedSalary"] as? Int ?? 300
        self.expectedMaximumSalary = data["maximumExpectedSalary"] as? Int ?? 0
        self.softSkills = data["softSkills"] as? [String] ?? []
        self.technicalSkills = data["technicalSkills"] as? [String] ?? []
        self.experience = data["experience"] as? [String] ?? []
        self.appliedJobs = data["appliedJobs"] as? [String] ?? []
        self.jobsBookmark = data["jobsBookmark"] as? [String] ?? []
        self.resourcesBookmark = data["resourcesBookmark"] as? [String] ?? []
        self.cvs = data["cvs"] as? [String] ?? []
        self.isApplicant = true
        self.isAdmin = false
        self.isEmployer = false
        
        if let dateOfBirthTimestamp = data["dateOfBirth"] as? Timestamp{
            self.dateOfBirth = Applicant.formatDate(dateOfBirthTimestamp.dateValue())
        }
        else{
            self.dateOfBirth = "N/A"
        }
    }
    
    static func formatDate(_ dateToFormat: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateToFormat)
    }
}
