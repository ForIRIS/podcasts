//
//  BestPodcasts.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

// API URL : https://www.listennotes.com/api/docs/?lang=swift&test=1#get-api-v2-best_podcasts
// Parse the required information.

import Foundation

struct BestPodcasts: Decodable {
    let id: Int
    let name: String
    let total: Int
    let hasNext: Bool
    let podcasts: [PodcastData]
    let parentID: Int
    let pageNumber: Int
    let hasPrevious: Bool
    let nextPageNumber: Int
    let previousPageNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case total
        case hasNext = "has_next"
        case podcasts
        case parentID = "parent_id"
        case pageNumber = "page_number"
        case hasPrevious = "has_previous"
        case nextPageNumber = "next_page_number"
        case previousPageNumber = "previous_page_number"
    }
}

struct PodcastData: Codable {
    let id: String
    let title: String
    let publisher: String
    let description: String?
    let thumbnail: String?
    let lastedPublishDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, publisher, description, thumbnail
        case lastedPublishDate = "latest_pub_date_ms"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        publisher = try values.decode(String.self, forKey: .publisher)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        lastedPublishDate = try values.decode(Date.self, forKey: .lastedPublishDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(publisher, forKey: .publisher)
        try container.encode(description, forKey: .description)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(lastedPublishDate, forKey: .lastedPublishDate)
    }
}
