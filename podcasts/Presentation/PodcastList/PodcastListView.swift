//
//  PodcastListView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

struct PodcastListView: View {
    @State var viewModel: PodcastListViewModel
    let coordinator: AppCoordinator
    
    init(_ podcastRepository: PodcastRepository, coordinator: AppCoordinator) {
        self.viewModel = PodcastListViewModel(listUseCase: PodcastListUsecase(repository: podcastRepository))
        self.coordinator = coordinator  
    }
    
    var body: some View {
        List {
            ForEach(0..<viewModel.podcasts.count, id: \.self) { index in
                PodcastListCellView(podcast: viewModel.podcasts[index])
                    .onTapGesture {
                        coordinator.navigateToDetail(podcast: viewModel.podcasts[index])
                    }
                    .onAppear {
                        // load more
                        if index == viewModel.podcasts.count - 1 && viewModel.hasNext && !viewModel.isLoading {
                            print("Loading more podcasts... currentOffset: \(viewModel.currentOffset)")
                            Task {
                                await viewModel.loadPodcast()
                            }
                        }
                    }
                    .listRowSeparator(.visible)
            }
            
            // loading indicator
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Podcasts")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadPodcast()
        }
    }
}
