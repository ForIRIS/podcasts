//
//  PodcastDetailView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

struct PodcastDetailView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @State var viewModel: PodcastDetailViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                header
                
                if let url = URL(string: viewModel.thumbnail) {
                    thumbnailImage(url: url)
                }
                
                actionButtons
                
                Text(viewModel.description)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
    
    private var header: some View {
        VStack {
            Text(viewModel.title)
                .font(.title2)
                .fontWeight(.semibold)
            Text(viewModel.publisher)
                .font(.title3)
                .italic()
                .foregroundStyle(.secondary)
        }
    }
    
    private func thumbnailImage(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().cornerRadius(12)
            case .failure:
                Image(systemName: "photo.trianglebadge.exclamationmark").resizable()
            case .empty:
                ProgressView()
            @unknown default:
                Image(systemName: "photo").resizable()
            }
        }
        .scaledToFit()
        .frame(width: 210, height: 210)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.playPause()
            } label: {
                Label(viewModel.isPlaying ? "Pause" : "Play", systemImage: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 44)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                viewModel.toggleFavourite()
            } label: {
                Label(viewModel.favourite ? "Favourited" : "Favourite", systemImage: viewModel.favourite ? "heart.fill" : "heart")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 44)
                    .background(.red, in: RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isProcessing)
        }
    }
}
