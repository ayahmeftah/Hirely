//
//  FilterOptions.swift
//  Hirely
//
//  Created by Ayah Meftah  on 26/12/2024.
//

import Foundation
import UIKit

enum City: String, CaseIterable {
    case manama = "Manama"
    case muharraq = "Muharraq"
    case isaTown = "Isa Town"
    case riffa = "Riffa"
    case aali = "A'ali"
    case sitra = "Sitra"
    case hamadTown = "Hamad Town"
    case busaiteen = "Busaiteen"
    case salmanabad = "Salmanabad"
    case jidhafs = "Jidhafs"
    case budaiya = "Budaiya"
    case diraz = "Duraz"
    case sanabis = "Sanabis"
    case alHidd = "Al Hidd"
    case zallaq = "Zallaq"
    case amwaj = "Amwaj Islands"
    case tubli = "Tubli"
    case seef = "Seef"
    case hoora = "Hoora"
    case adliya = "Adliya"
    case juffair = "Juffair"
    case salmaniya = "Salmaniya"
    case diyar = "Diyar Al Muharraq"
}

enum ExperienceLevel: String, CaseIterable {
    case junior = "Junior"
    case associate = "Associate"
    case midLevel = "Mid-level"
    case senior = "Senior"
    case lead = "Lead"
    case manager = "Manager"
}

enum JobType: String, CaseIterable {
    case fullTime = "Full-time"
    case partTime = "Part-time"
    case internship = "Internship"
    case contract = "Contract"
}

enum LocationType: String, CaseIterable {
    case onSite = "On-site"
    case remote = "Remote"
    case hybrid = "Hybrid"
}

