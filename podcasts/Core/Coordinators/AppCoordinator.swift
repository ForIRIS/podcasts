//
//  AppCoordinator.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

enum AppRoutes: Hashable {
    case podcastDetail(Podcast)
    case podcastSearchDetail(Podcast)
}

@Observable
class AppCoordinator {
    var path = NavigationPath()
    var searchPath = NavigationPath()
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func navigateToDetail(podcast: Podcast) {
        path.append(AppRoutes.podcastDetail(podcast))
    }
    
    func navigationBack() {
        path.removeLast()
    }
    
    @ViewBuilder
    func build(_ route: AppRoutes) -> some View {
        switch route {
        case .podcastDetail(let podcast), .podcastSearchDetail(let podcast):
            let viewModel = PodcastDetailViewModel(
                podcast: podcast,
                audioPlayerService: diContainer.audioPlayerService,
                detailUsecase: diContainer.podcastDetailUsecase
            )
            PodcastDetailView(viewModel: viewModel)
        }
    }
}
