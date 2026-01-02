
//
//  DIContainer.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-18.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class DIContainer {
    // MARK: - Services
    let apiService: APIService
    let audioPlayerService: AudioPlayerService
    
    // MARK: - Data Layer
    let modelContext: ModelContext
    let podcastRepository: PodcastRepository
    
    // MARK: - Usecases
    let podcastListUsecase: PodcastListUsecase
    let podcastSearchUsecase: PodcastSearchUsecase
    let podcastDetailUsecase: PodcastDetailUsecase
    
    init() {
        // Services
        self.apiService = APIService()
        self.audioPlayerService = AudioPlayerService()
        
        // Data Layer
        let modelContainer = Persistence.shared.container
        self.modelContext = ModelContext(modelContainer)
        self.podcastRepository = PodcastRepository(apiService: apiService, context: modelContext)
        
        // Usecases
        self.podcastListUsecase = PodcastListUsecase(repository: podcastRepository)
        self.podcastSearchUsecase = PodcastSearchUsecase(repository: podcastRepository)
        self.podcastDetailUsecase = PodcastDetailUsecase(repository: podcastRepository)
    }
}
