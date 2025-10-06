//
//  PodcastDetailUsecase.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-06.
//

actor PodcastDetailUsecase {
    private let repository: PodcastRepository
    
    init(repository: PodcastRepository) {
        self.repository = repository
    }
    
    func toggleFavorite(podcastId: String) async throws {
        try await repository.toggleFavourite(podcastId: podcastId)
    }
    
    /// TODO??
}
