//
//  PodcastRepository.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class PodcastRepository {
    private let apiService: APIService
    private let context: ModelContext
    
    init(apiService: APIService, context: ModelContext) {
        self.apiService = apiService
        self.context = context
    }
    
    func fetchCachedPodcasts() async throws -> [Podcast] {
        let descriptor = FetchDescriptor<Podcast>(sortBy: [SortDescriptor(\.lastUpdatedAt, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetchBestPodcasts(genreId: String, offset: Int) async throws -> BestPodcasts {
        try await apiService.fetchBestPodcasts(genreId: genreId, page: offset)
    }
    
    func search(query: String) async throws -> [Podcast] {
        let predicate = #Predicate<Podcast> { podcast in podcast.title.localizedStandardContains(query) }
        let descriptor = FetchDescriptor<Podcast>(predicate: predicate, sortBy: [SortDescriptor(\.lastUpdatedAt, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func insertOrUpdatePodcasts(_ podcasts: [PodcastData]) async throws {
        for podcast in podcasts {
            if let existing = try? context.fetch(FetchDescriptor<Podcast>(predicate: #Predicate { $0.id == podcast.id })).first {
                existing.title = podcast.title
                existing.podDescription = podcast.description
                existing.lastUpdatedAt = .now
            } else {
                context.insert(Podcast(from: podcast))
            }
        }
        try context.save()
    }
    
    func toggleFavourite(podcastId: String) async throws {
        let descriptor: FetchDescriptor<Podcast> = .init(predicate: #Predicate { $0.id == podcastId })
        guard let podcast = try? context.fetch(descriptor).first else {
            throw DataStoreError.invalidPredicate
        }
        
        podcast.favourite.toggle()
        try context.save()
    }
}
