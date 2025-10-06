//
//  Persistence.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import SwiftData

// Keep the SwiftData schema version up to date
typealias SchemaLatest = SchemaVersion100

class Persistence {
    static let shared = Persistence()
    
    let container: ModelContainer
    
    private init() {
        do {
            let schema = Schema(versionedSchema: SchemaLatest.self)
            
            container = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    func context() -> ModelContext {
        return container.mainContext
    }
}
