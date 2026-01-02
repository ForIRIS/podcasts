

//
//  PodcastSearchView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-18. 
//

import SwiftUI

struct PodcastSearchView: View {
    @State var viewModel: PodcastSearchViewModel
    
    var body: some View {
        // The NavigationStack should be provided by the parent (ContentView)
        content
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search for podcasts")
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.updateSearchText(newValue)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            if viewModel.searchText.isEmpty {
                Text("Enter a search term to begin.")
                    .foregroundColor(.secondary)
            } else {
                Text("No results for \(viewModel.searchText)")
                    .foregroundColor(.secondary)
            }
        case .loading:
            ProgressView()
        case .loaded:
            List(viewModel.podcasts, id: \.id) {
                podcast in
                NavigationLink(value: AppRoutes.podcastSearchDetail(podcast)) {
                    // Simple cell view, can be extracted later
                    VStack(alignment: .leading) {
                        Text(podcast.title)
                            .font(.headline)
                        Text(podcast.publisher)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        case .error(let message):
            Text("Error: \(message)")
                .foregroundColor(.red)
        }
    }
}
