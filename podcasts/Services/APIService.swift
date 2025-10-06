//
//  APIService.swift
//  podcasts
//
//  Created by KAK KYOO LEE on 2025-10-05.
//
//  API service for fetching podcast data from Listen Notes API.
//  Uses the official PodcastAPI SDK for iOS with mock data support.
//

import Foundation
import PodcastAPI

class APIService {
    /// PodcastAPI client instance (configured for mock data)
    private let client = PodcastAPI.Client(apiKey: "", synchronousRequest: true)
    
    /**
     Fetch best podcasts for a specific genre and page.
     
     - Parameters:
       - genreId: The genre ID to fetch podcasts for
       - page: The page number for pagination (0-based)
     
     - Returns: BestPodcasts object containing the fetched data
     
     - Throws: PodcastApiError if the API request fails
     */
    func fetchBestPodcasts(genreId: String, page: Int) async throws -> BestPodcasts {
        try await withCheckedThrowingContinuation { continuation in
            var parameters: [String: String] = [:]
            parameters["page"] = "\(page)"
            parameters["genre_id"] = genreId
            // mock parameters
            
            client.fetchBestPodcasts(parameters: parameters) { response in
                if let error = response.error {
                    switch (error) {
                    case PodcastApiError.authenticationError:
                        print("‼️ : Invalid error : wrong api key but It's mock api so no need to handle this case")
                    default:
                        print("error: \(error)")
                    }
                } else {
                    guard let json = response.toJson() else // It's a SwiftyJSON object
                    {
                        return continuation.resume(throwing: PodcastApiError.invalidRequestError)
                    }
                    
                    do {
                        let data = try json.rawData()
                        let bestPodcasts = try JSONDecoder().decode(BestPodcasts.self, from: data)
                        continuation.resume(returning: bestPodcasts)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
