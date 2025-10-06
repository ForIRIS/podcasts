//
//  podcastsApp.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI
import SwiftData

@main
struct podcastsApp: App {
    @State var repository = PodcastRepository(apiService: APIService(), context: Persistence.shared.context())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(repository)
                .modelContainer(Persistence.shared.container)
        }
    }
}
