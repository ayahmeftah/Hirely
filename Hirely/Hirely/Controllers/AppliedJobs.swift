//
//  AppliedJobs.swift
//  Hirely
//
//  Created by BP-36-208-07 on 27/12/2024.
//

import Foundation
import FirebaseFirestore

struct JobApplication {
    var age: String
    var applicationStatus: String
    var cv: String
    var dateApplied: Timestamp
    var docId: String
    var email: String
    var fullName: String
    var jobId: String
    var phoneNumber: String
    var scheduledInterviewId: String
    var userId: String

    init(data: [String: Any]) {
        self.age = data["age"] as? String ?? ""
        self.applicationStatus = data["applicationStatus"] as? String ?? ""
        self.cv = data["cv"] as? String ?? ""
        self.dateApplied = data["dateApplied"] as? Timestamp ?? Timestamp(date: Date()) // Default to current timestamp
        self.docId = data["docId"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.jobId = data["jobId"] as? String ?? ""
        self.phoneNumber = data["phoneNumber"] as? String ?? ""
        self.scheduledInterviewId = data["scheduledInterviewId"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
    }
}


