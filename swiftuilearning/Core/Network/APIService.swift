//
//  APIService.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    /// Fetches the word of the day from the API
    func fetchWordOfTheDay() async throws -> WordOfTheDay {
        guard let url = URL(string: APIEndpoints.wordOfTheDayURL) else {
            throw AppErrors.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw AppErrors.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WordOfTheDay.self, from: data)
        } catch let error as AppErrors {
            throw error
        } catch is DecodingError {
            throw AppErrors.decodingError
        } catch {
            throw AppErrors.networkError
        }
    }
    
    /// Fetches user statistics from the API
    /// Currently returns mock data - replace with actual API call
    func fetchUserStats() async throws -> UserStats {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Mock data - Replace this with actual API call
        return UserStats(
            dayStreak: 7,
            wordsLearned: 42,
            savedWords: 12
        )
        
        /*
         // Example of actual API implementation:
         let url = URL(string: "\(APIEndpoints.baseURL)/user/stats")!
         let (data, _) = try await URLSession.shared.data(from: url)
         let stats = try JSONDecoder().decode(UserStats.self, from: data)
         return stats
         */
    }
    
    /// Saves a word to the user's saved words list
    func saveWord(wordId: String) async throws -> Bool {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock success - Replace with actual API call
        return true
        
        /*
         // Example of actual API implementation:
         let url = URL(string: "\(APIEndpoints.baseURL)/user/saved-words")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         let body = ["wordId": wordId]
         request.httpBody = try JSONEncoder().encode(body)
         
         let (data, response) = try await URLSession.shared.data(for: request)
         guard let httpResponse = response as? HTTPURLResponse,
         httpResponse.statusCode == 200 else {
         throw AppErrors.networkError
         }
         return true
         */
    }
}
