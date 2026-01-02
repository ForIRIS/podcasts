//
//  ContentView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

struct ContentView: View {
    @Environment(DIContainer.self) private var diContainer
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        let bindable = Bindable(coordinator)
        
        TabView {
            // Podcast List Tab
            NavigationStack(path: bindable.path) {
                PodcastListView(viewModel: PodcastListViewModel(listUseCase: diContainer.podcastListUsecase))
                    .navigationDestination(for: AppRoutes.self) { route in
                        coordinator.build(route)
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            // Search Tab
            NavigationStack(path: bindable.searchPath) {
                let viewModel = PodcastSearchViewModel(searchUsecase: diContainer.podcastSearchUsecase)
                PodcastSearchView(viewModel: viewModel)
                    .navigationDestination(for: AppRoutes.self) { route in
                        coordinator.build(route)
                    }
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
    }
}

