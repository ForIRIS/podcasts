//
//  PodcastDetailViewModel.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

@Observable
class PodcastDetailViewModel {
    var title: String { podcast.title }
    var publisher: String { podcast.publisher }
    var thumbnail: String { podcast.thumbnail ?? "" }
    var description: String { podcast.podDescription ?? "" }
    var favourite: Bool { podcast.favourite }
    var isProcessing: Bool = false
    
    private var podcast: Podcast
    private let detailUseCase: PodcastDetailUsecase
    
    init(detailUseCase: PodcastDetailUsecase, podcast: Podcast) {
        self.detailUseCase = detailUseCase
        self.podcast = podcast
    }
    
    func toggleFavourite() {
        guard !isProcessing else {
            print("toggle Favourite is processing...")
            return
        }
        
        isProcessing = true
        
        Task { @MainActor in
            do {
                try await self.detailUseCase.toggleFavorite(podcastId: self.podcast.id)
            } catch {
                print("Error toggle podcast favourite: \(error)")
            }
            
            isProcessing = false
        }
    }
}
