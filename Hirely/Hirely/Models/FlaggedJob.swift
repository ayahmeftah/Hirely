//
//  FlaggedJob.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 26/12/2024.
//

import Foundation
import FirebaseCore

struct FlaggedJob {
    let docId: String
    let jobId: String
    let flagReason: String
    let comments: String
    let flaggedDate: Date
    let status: FlagState

    //Initializer to create FlaggedJob object from firestore data
    init?(docId: String, data: [String: Any]) {
        guard let jobId = data["jobId"] as? String,
              let flagReason = data["flagReason"] as? String,
              let comments = data["comment"] as? String,
              let flaggedDateTimestamp = data["flagDate"] as? Timestamp,
              let statusString = data["status"] as? String else {
            return nil
        }
        
        self.docId = docId
        self.jobId = jobId
        self.flagReason = flagReason
        self.comments = comments
        self.flaggedDate = flaggedDateTimestamp.dateValue()
        self.status = FlagState(rawValue: statusString.lowercased()) ?? .flagged
    }
}
