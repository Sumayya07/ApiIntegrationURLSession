//
//  modelData.swift
//  ApiIntegration
//
//  Created by Sumayya Siddiqui on 16/03/23.
//

import Foundation

// If we are using a GET API we can choose how many elements we can fetch from the API.
// But in case of POST API we have to pass all the key value pairs.

// GET API: FETCH THE DATA FROM THE SERVER
// POST API: POST/GIVE THE DATA TO THE SERVER

// MARK: - TaskElement
struct TaskElement: Codable {
    let copyright: String?
    let date, explanation: String
    let hdurl: String?
    let mediaType: MediaType
    let serviceVersion: ServiceVersion
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
}

enum ServiceVersion: String, Codable {
    case v1 = "v1"
}

typealias Task = [TaskElement]
