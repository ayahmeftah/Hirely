//
//  CompanyDetails.swift
//  Hirely
//
//  Created by BP-needchange on 25/12/2024.
//

import Foundation
import FirebaseFirestore

struct CompanyDetails {
    var benefit: String
    var companyPicture: String
    var docId: String
    var growth: String
    var name: String
    var overview: String
    var specialization: String

    init(data: [String: Any]) {
        self.benefit = data["benefit"] as? String ?? ""
        self.companyPicture = data["companyPicture"] as? String ?? ""
        self.docId = data["docId"] as? String ?? ""
        self.growth = data["growth"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.overview = data["overview"] as? String ?? ""
        self.specialization = data["specialization"] as? String ?? ""
    }
}
