//
//  ColleagueModel.swift
//  DirectoryApp
//
//  Created by Geethika on 08/05/22.
//

import Foundation
// MARK: - Models

typealias ColleagueList = [Colleague]

/// Colleague Data Model
struct Colleague: Codable {
    let createdAt, firstName: String
    let avatar: String
    let lastName, email, jobtitle, favouriteColor: String
    let id: String
    let data: CallData?
    let to, fromName: String?
}

/// Call Data Model
struct CallData: Codable {
    let title, body, id, toID: String
    let fromID, meetingid: String

    enum CodingKeys: String, CodingKey {
        case title, body, id
        case toID = "toId"
        case fromID = "fromId"
        case meetingid
    }
}
