//
//  PodcastListViewModel.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

@Observable
class PodcastListViewModel {
    var podcasts: [Podcast] = []
    var currentOffset: Int = 0
    var isLoading: Bool = false
    var errorMessage: String?
    
    var hasNext: Bool = true
    
    private let listUseCase: PodcastListUsecase
    
    init(listUseCase: PodcastListUsecase) {
        self.listUseCase = listUseCase
    }
    
    func loadPodcast() async {
        guard !isLoading else { 
            print("Already loading, skipping...")
            return 
        }
        
        print("Starting to load podcasts with offset: \(currentOffset)")
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await listUseCase.fetch(currentOffset: currentOffset)
            print("Fetched \(result.page.count) podcasts, hasNext: \(result.hasNext)")
            self.podcasts.append(contentsOf: result.page)
            self.currentOffset += result.page.count
            self.hasNext = result.hasNext
            print("Updated: total podcasts: \(self.podcasts.count), currentOffset: \(self.currentOffset), hasNext: \(self.hasNext)")
        } catch {
            print("Error loading podcasts: \(error)")
            self.errorMessage = "Failed to load podcast : \(error)"
        }
        
        self.isLoading = false
    }
}
