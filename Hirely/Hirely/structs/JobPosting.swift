//
//  JobPosting.swift
//  Hirely
//
//  Created by BP-needchange on 25/12/2024.
//

import Foundation
import FirebaseCore


struct JobPosting {
    let docId: String
    var jobTitle: String
    var jobType: String
    var locationType: String
    var city: String
    var experienceLevel: String
    var skills: [String]
    var postedDate: String
    var minSalary: Int
    var maxSalary: Int
    var jobDescription: String
    var jobRequirements: String
    var contactEmail: String
    var deadline: String
    var isHidden: Bool
    
    init(data: [String: Any]) {
        self.docId = data["docId"] as? String ?? ""
        self.jobTitle = data["jobTitle"] as? String ?? "No Title"
        self.jobType = data["jobType"] as? String ?? "N/A"
        self.locationType = data["locationType"] as? String ?? "N/A"
        self.city = data["city"] as? String ?? "N/A"
        self.experienceLevel = data["experienceLevel"] as? String ?? "N/A"
        self.skills = data["skills"] as? [String] ?? []
        self.minSalary = data["minimumSalary"] as? Int ?? 0
        self.maxSalary = data["maximumSalary"] as? Int ?? 0
        self.jobDescription = data["jobDescription"] as? String ?? "No Description"
        self.jobRequirements = data["jobRequirements"] as? String ?? "No Requirements"
        self.contactEmail = data["contactEmail"] as? String ?? "No Email"
        self.isHidden = data["isHidden"] as? Bool ?? false
        
        // Handle Firestore Timestamps and convert to String
        if let postedTimestamp = data["postedDate"] as? Timestamp {
            self.postedDate = JobPosting.formatDate(postedTimestamp.dateValue())
        } else {
            self.postedDate = "N/A"
        }
        
        if let deadlineTimestamp = data["deadline"] as? Timestamp {
            self.deadline = JobPosting.formatDate(deadlineTimestamp.dateValue())
        } else {
            self.deadline = "N/A"
        }
    }
    
    // Helper function to format the date
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
