//
//  PodcastDetailView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

struct PodcastDetailView: View {
    @State var viewModel: PodcastDetailViewModel
    let coordinator: AppCoordinator
    
    init(_ podcastRepository: PodcastRepository, _ podcast: Podcast, coordinator: AppCoordinator) {
        viewModel = PodcastDetailViewModel(detailUseCase: PodcastDetailUsecase(repository: podcastRepository), podcast: podcast)
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 32) {
                VStack {
                    Text("\(viewModel.title)")
                        .font(.title2)
                    Text("\(viewModel.publisher)")
                        .font(.title3)
                        .italic()
                        .foregroundStyle(Color(.secondaryLabel))
                }
                
                if let url = URL(string: viewModel.thumbnail) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 210, height: 210)
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .resizable()
                                .frame(width: 210, height: 210)
                        case .empty:
                            ProgressView()
                                .frame(width: 210, height: 210)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 210, height: 210)
                        }
                    }
                }
                
                Button {
                    viewModel.toggleFavourite()
                } label : {
                    Text( viewModel.favourite ? "Favourited" : "Favourite")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 40)
                        .background(.red)
                        .cornerRadius(12)
                }
                .contentShape(Rectangle())
                .disabled(viewModel.isProcessing)
                
                Text("\(viewModel.description)")
                    .foregroundStyle(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.primary)
                .onTapGesture {
                    coordinator.navigationBack()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
