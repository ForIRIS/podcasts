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
    
    // Audio Player State
    var isPlaying: Bool = false // This should reflect the audio player's state
    
    private var podcast: Podcast
    private let audioPlayerService: AudioPlayerService
    private let detailUsecase: PodcastDetailUsecase
    
    init(podcast: Podcast, audioPlayerService: AudioPlayerService, detailUsecase: PodcastDetailUsecase) {
        self.podcast = podcast
        self.audioPlayerService = audioPlayerService
        self.detailUsecase = detailUsecase
        // Here you would typically observe the audioPlayerService for state changes
    }
    
    func playPause() {
        // Simplified play/pause logic
        // A real implementation would involve checking the player's current item, etc.
        if isPlaying {
            // audioPlayerService.pause()
        } else {
            // audioPlayerService.play(podcast)
        }
        isPlaying.toggle() // a mock toggle for UI
        print("Play/Pause toggled for \(podcast.title)")
    }
    
    @MainActor
    func toggleFavourite() {
        guard !isProcessing else {
            print("toggle Favourite is processing...")
            return
        }
        
        isProcessing = true
        
        Task { @MainActor in
            do {
                try await self.detailUsecase.toggleFavorite(podcastId: self.podcast.id)
                // The @Observable property on the Podcast model should trigger UI updates automatically
            } catch {
                print("Error toggle podcast favourite: \(error)")
            }
            
            isProcessing = false
        }
    }
}