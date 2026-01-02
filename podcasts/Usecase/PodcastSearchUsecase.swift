//
//  PodcastSearchUsecase.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-18.
//

import Foundation

actor PodcastSearchUsecase {
    private let repository: PodcastRepository
    
    init(repository: PodcastRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [Podcast] {
        // Add any business logic here in the future (e.g., filtering, modifying results)
        return try await repository.search(query: query)
    }
}
