//
//  PodcastListUsecase.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import Foundation

enum PodcastListUsecaseError : Error {
    case fetchDateError
    case fetchNoMoreData
}


actor PodcastListUsecase {
    private let repository: PodcastRepository
    private let pageSize: Int = 10
    private let apiPageSize: Int = 20 // API can't control reponse podcasts count.
    
    private var lastFetchAt: Date?
    private var hasNext: Bool = true
    
    init(repository: PodcastRepository) {
        self.repository = repository
    }
    
    func fetch(genreId: String = "93", currentOffset: Int) async throws -> (page:[Podcast], hasNext: Bool) {
        if lastFetchAt == nil {
            lastFetchAt = .now
        }
        
        guard let lastFetchAt = lastFetchAt else {
            throw PodcastListUsecaseError.fetchDateError
        }
        
        // Check cached podcasts
        let cachedPodcasts = try await repository.fetchCachedPodcasts().filter { $0.lastUpdatedAt >= lastFetchAt }
        if !cachedPodcasts.isEmpty, currentOffset < cachedPodcasts.count {
            let total = cachedPodcasts.count
            let endIndex = min(currentOffset + pageSize, total)
            
            let page = Array(cachedPodcasts[currentOffset..<endIndex])
            return (page, endIndex < total || hasNext)
        }
        
        // When data needs to be fetched from the API
        // Since the API returns 20 items at a time, to paginate in chunks of 10:
        // - 0–9: API offset 0
        // - 10–19: API offset 0
        // - 20–29: API offset 1
        // - 30–39: API offset 1
        let apiOffset = currentOffset / apiPageSize
        
        let bestPodcasts = try await repository.fetchBestPodcasts(genreId: genreId, offset: apiOffset)
        
        guard !bestPodcasts.podcasts.isEmpty else {
            throw PodcastListUsecaseError.fetchNoMoreData
        }
        
#if DEBUG
        // The data does not grow with page increments, which might be a problem with the mock API...
        for podcast in bestPodcasts.podcasts {
            print("\(podcast.id) : \(podcast.title)")
        }
#endif
        
        self.hasNext = bestPodcasts.hasNext
        
        try await repository.insertOrUpdatePodcasts(bestPodcasts.podcasts)
        let savedPodcasts = try await repository.fetchCachedPodcasts().filter { $0.lastUpdatedAt >= lastFetchAt }
        
        guard currentOffset < savedPodcasts.count else {
            throw PodcastListUsecaseError.fetchNoMoreData
        }
        
        let total = savedPodcasts.count
        let endIndex = min(currentOffset + pageSize, total)
        
        // When the data fetched from the API does not include the requested page
        guard currentOffset < total else {
            throw PodcastListUsecaseError.fetchNoMoreData
        }
        
        let page = Array(savedPodcasts[currentOffset..<endIndex])
        
        // hasNext check:
        // 1. Verify if more data can be fetched from the current API response
        // 2. Or check if the API has more data (if the API returns fewer than 20 items, it's the end)
        let hasMoreInCurrentApiData = endIndex < total
        
        return (page, hasMoreInCurrentApiData || self.hasNext)
    }
}

