//
//  PodcastSearchViewModel.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-18.
//

import Foundation
import Observation
import Combine

@Observable
final class PodcastSearchViewModel {
    
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    var searchText: String = ""
    var state: State = .idle
    var podcasts: [Podcast] = []
    
    private let searchUsecase: PodcastSearchUsecase
    private var searchTask: Task<Void, Never>?
    
    init(searchUsecase: PodcastSearchUsecase) {
        self.searchUsecase = searchUsecase
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5)) // Manual debounce
            if !Task.isCancelled && !text.isEmpty {
                await performSearch(query: text)
            } else if text.isEmpty {
                state = .idle
            }
        }
    }
    
    @MainActor
    private func performSearch(query: String) async {
        state = .loading
        do {
            let results = try await searchUsecase.execute(query: query)
            self.podcasts = results
            self.state = .loaded
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
