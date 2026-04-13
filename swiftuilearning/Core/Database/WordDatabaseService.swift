//
//  WordDatabaseService.swift
//  swiftuilearning
//
//  Handles all local database operations for saved words.
//  Callers must pass ModelContext from the SwiftUI environment.
//

import Foundation
import SwiftData

enum WordDatabaseError: Error {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case contextUnavailable
}

final class WordDatabaseService {
    
    static let shared = WordDatabaseService()
    
    private init() {}
    
    // MARK: - Save
    
    /// Saves the current day's word to the local database. If the same word for the same date already exists, does nothing and returns success (no duplicate).
    /// Inserts a copy of the word so the displayed (transient) instance is not managed by the context.
    func save(word: WordOfTheDay, context: ModelContext) throws {
        do {
            let alreadySaved = try exists(date: word.date, wordText: word.word, context: context)
            if alreadySaved {
                return
            }
            let copy = WordOfTheDay(
                id: word.id,
                word: word.word,
                meaning: word.meaning,
                partOfSpeech: word.partOfSpeech,
                date: word.date,
                example: word.example,
                source: word.source,
                sourceUrl: word.sourceUrl,
                etymology: word.etymology,
                savedAt: Date()
            )
            context.insert(copy)
            try context.save()
        } catch {
            context.rollback()
            throw AppErrors.databaseSaveFailed
        }
    }
    
    // MARK: - Fetch
    
    /// Fetches all saved words, most recent first.
    func fetchAll(context: ModelContext) throws -> [WordOfTheDay] {
        let descriptor = FetchDescriptor<WordOfTheDay>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            throw AppErrors.databaseFetchFailed
        }
    }
    
    /// Fetches a page of saved words for list pagination. Sorted by savedAt descending.
    func fetchSavedWords(offset: Int, limit: Int, context: ModelContext) throws -> [WordOfTheDay] {
        var descriptor = FetchDescriptor<WordOfTheDay>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = offset
        do {
            return try context.fetch(descriptor)
        } catch {
            throw AppErrors.databaseFetchFailed
        }
    }
    
    /// Returns the count of saved words (for the Saved Words stat).
    func fetchCount(context: ModelContext) throws -> Int {
        let descriptor = FetchDescriptor<WordOfTheDay>()
        do {
            return try context.fetchCount(descriptor)
        } catch {
            throw AppErrors.databaseFetchFailed
        }
    }
    
    /// Returns today's word from the local database when it exists (e.g. user saved it earlier). Date format should match API (e.g. yyyy-MM-dd).
    func fetchWordForDate(date: String, context: ModelContext) throws -> WordOfTheDay? {
        var descriptor = FetchDescriptor<WordOfTheDay>(
            predicate: #Predicate<WordOfTheDay> { item in item.date == date },
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        do {
            let results = try context.fetch(descriptor)
            return results.first
        } catch {
            throw AppErrors.databaseFetchFailed
        }
    }
    
    // MARK: - Delete
    
    /// Deletes a saved word by id.
    func delete(id: String, context: ModelContext) throws {
        let descriptor = FetchDescriptor<WordOfTheDay>(
            predicate: #Predicate<WordOfTheDay> { $0.id == id }
        )
        do {
            let items = try context.fetch(descriptor)
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            context.rollback()
            throw AppErrors.databaseDeleteFailed
        }
    }
    
    /// Returns true if a word with the given date and word text is already saved (avoids duplicates for same day).
    func exists(date: String, wordText: String, context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<WordOfTheDay>(
            predicate: #Predicate<WordOfTheDay> { item in
                item.date == date && item.word == wordText
            }
        )
        do {
            let count = try context.fetchCount(descriptor)
            return count > 0
        } catch {
            throw AppErrors.databaseFetchFailed
        }
    }
}
