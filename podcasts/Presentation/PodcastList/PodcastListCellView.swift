//
//  PodcastListCellView.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

struct PodcastListCellView: View {
    @Bindable var podcast: Podcast
    
    var body: some View {
        HStack {
            if let thumbnail = podcast.thumbnail,
               let url = URL(string: thumbnail) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                        .resizable()
                        .frame(width: 72, height: 72)
                        .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo.trianglebadge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                    case .empty:
                        ProgressView()
                            .frame(width: 72, height: 72)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                    }
                }
                .padding([.vertical, .trailing], 8)
            }
            
            VStack(alignment: .leading) {
                Text(podcast.title)
                    .fontWeight(.bold)
                Text(podcast.publisher)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.gray)
                if podcast.favourite {
                    Text("Favourited")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            Spacer(minLength: 0)
        }
    }
}
