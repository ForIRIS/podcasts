//
//  ContentView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI
import SwiftData

/**
 Main content view that serves as the root of the navigation hierarchy.
 
 This view manages:
 - Navigation between podcast list and detail screens
 - AppCoordinator for navigation state management
 - Environment dependencies injection
 */
struct ContentView: View {
    @State private var coordinator = AppCoordinator()
    @Environment(\.modelContext) private var modelContext
    @Environment(PodcastRepository.self) private var podcastRepository

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            PodcastListView(podcastRepository, coordinator: coordinator)
                .navigationDestination(for: AppRoutes.self) { route in
                    // If there are many routes, consider using a Router and DI.
                    // Currently, handle directly.
                    switch route {
                    case .podcastDetail(let podcast):
                        PodcastDetailView(podcast, coordinator: coordinator)
                    }
                }
        }
    }
}

#Preview {
    let repository = PodcastRepository(apiService: APIService(),
                                       context: Persistence.shared.context())
    ContentView()
        .environment(repository)
        .modelContainer(Persistence.shared.container)
}
