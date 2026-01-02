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
    @State private var diContainer = DIContainer()
    @State private var coordinator: AppCoordinator
    
    init() {
        let container = DIContainer()
        _diContainer = State(initialValue: container)
        _coordinator = State(initialValue: AppCoordinator(diContainer: container))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(diContainer)
                .environment(coordinator)
                .modelContainer(Persistence.shared.container)
        }
    }
}