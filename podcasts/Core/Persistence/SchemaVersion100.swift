//
//  SchemaVersion100.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//

import Foundation
import SwiftData

public enum SchemaVersion100: VersionedSchema {
    public static var versionIdentifier = Schema.Version(1, 0, 0)
    public static var models: [any PersistentModel.Type] = [Podcast.self]
}

