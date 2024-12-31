//
//  Employer.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 31/12/2024.
//

import Foundation

struct Employer {
    let id: String
    let firstName: String
    let lastName: String
    let profilePhoto: String
    let status: String
    let dateOfBirth: Date?
    let phoneNumber: String
    let email: String
    let gender: String
    let city: String

    //computed property to calculate age
    var age: Int? {
        guard let dob = dateOfBirth else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: dob, to: Date())
        return components.year
    }

    //computed property for full name
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

