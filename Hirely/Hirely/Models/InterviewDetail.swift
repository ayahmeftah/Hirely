//
//  InterviewDetail.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 28/12/2024.
//

import Foundation
import FirebaseFirestore

import Foundation
import FirebaseFirestore

struct InterviewDetail {
    let docId: String
    var applicantId: String
    var employerId: String
    var jobId: String
    var location: String
    var notes: String
    var date: Timestamp
    var time: Timestamp

    init(data: [String: Any]) {
        self.docId = data["docId"] as? String ?? ""
        self.applicantId = data["applicantId"] as? String ?? ""
        self.employerId = data["employerId"] as? String ?? ""
        self.jobId = data["jobId"] as? String ?? ""
        self.location = data["location"] as? String ?? "No Location"
        self.notes = data["notes"] as? String ?? "No Notes"
        self.date = data["date"] as? Timestamp ?? Timestamp(date: Date()) // Default to current timestamp
        self.time = data["time"] as? Timestamp ?? Timestamp(date: Date()) // Default to current timestamp
    }
}
