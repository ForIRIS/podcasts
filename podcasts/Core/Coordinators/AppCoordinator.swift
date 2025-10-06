//
//  AppCoordinator.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftUI

enum AppRoutes: Hashable {
    case podcastDetail(Podcast)
}

/**
 Navigation coordinator using NavigationPath.
 
 - Note: Uses @Observable for automatic UI updates when navigation state changes
 */
@Observable
class AppCoordinator {
    var path = NavigationPath()
    
    func navigateToDetail(podcast: Podcast) {
        path.append(AppRoutes.podcastDetail(podcast))
    }
    
    func navigationBack() {
        path.removeLast()
    }
}
