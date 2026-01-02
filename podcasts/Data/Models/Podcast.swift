//
//  Podcast.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import Foundation
import SwiftData

@Model
final class Podcast: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var title: String
    var publisher: String
    var podDescription: String?
    var thumbnail: String?
    var urlString: String?
    var localPath: URL?
    var favourite: Bool
    var lastedPublishDate: Date
    var lastUpdatedAt: Date
    
    var url: URL? {
        guard let urlString else { return nil }
        return URL(string: urlString)
    }
    
    init(id: String,
         title: String,
         publisher: String,
         description: String? = nil,
         thumbnail: String? = nil,
         urlString: String? = nil,
         favourite: Bool,
         lastedPublishDate: Date,
         lastUpdatedAt: Date) {
        self.id = id
        self.title = title
        self.publisher = publisher
        self.podDescription = description
        self.thumbnail = thumbnail
        self.urlString = urlString
        self.favourite = favourite
        self.lastedPublishDate = lastedPublishDate
        self.lastUpdatedAt = lastUpdatedAt
    }
    
    init(from data: PodcastData) {
        self.id = data.id
        self.title = data.title
        self.publisher = data.publisher
        self.lastedPublishDate = data.lastedPublishDate
        if let description = data.description {
            self.podDescription = description
        }
        if let thumbnail = data.thumbnail {
            self.thumbnail = thumbnail
        }
        if let urlString = data.listennotesUrl {
            self.urlString = urlString
        }
        
        self.favourite = false
        self.lastUpdatedAt = .now
    }
    
    func update(with data: PodcastData) {
        self.title = data.title
        self.publisher = data.publisher
        self.lastedPublishDate = data.lastedPublishDate
        if let description = data.description {
            self.podDescription = description
        }
        if let thumbnail = data.thumbnail {
            self.thumbnail = thumbnail
        }
        if let urlString = data.listennotesUrl {
            self.urlString = urlString
        }
    }
}
