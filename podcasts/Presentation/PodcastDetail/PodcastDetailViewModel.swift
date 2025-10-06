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
    
    private var podcast: Podcast
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
    
    func toggleFavourite() {
        podcast.favourite.toggle()
    }
}
