//
//  WordOfTheDay.swift
//  swiftuilearning
//
//  Single model used for both API response parsing and database persistence.
//

import Foundation
import SwiftData

@Model
final class WordOfTheDay: Identifiable, Codable {
    var id: String
    var word: String
    var meaning: String
    var partOfSpeech: String
    var date: String
    var example: String
    var source: String
    var sourceUrl: String
    var etymology: String
    var savedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case word, meaning, partOfSpeech, date, example, source, sourceUrl, etymology
    }
    
    init(
        id: String = UUID().uuidString,
        word: String,
        meaning: String,
        partOfSpeech: String,
        date: String,
        example: String,
        source: String,
        sourceUrl: String,
        etymology: String,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.partOfSpeech = partOfSpeech
        self.date = date
        self.example = example
        self.source = source
        self.sourceUrl = sourceUrl
        self.etymology = etymology
        self.savedAt = savedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        word = try container.decode(String.self, forKey: .word)
        meaning = try container.decode(String.self, forKey: .meaning)
        partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        date = try container.decode(String.self, forKey: .date)
        example = try container.decodeIfPresent(String.self, forKey: .example) ?? ""
        source = try container.decode(String.self, forKey: .source)
        sourceUrl = try container.decode(String.self, forKey: .sourceUrl)
        etymology = try container.decodeIfPresent(String.self, forKey: .etymology) ?? ""
        savedAt = Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(word, forKey: .word)
        try container.encode(meaning, forKey: .meaning)
        try container.encode(partOfSpeech, forKey: .partOfSpeech)
        try container.encode(date, forKey: .date)
        try container.encode(example, forKey: .example)
        try container.encode(source, forKey: .source)
        try container.encode(sourceUrl, forKey: .sourceUrl)
        try container.encode(etymology, forKey: .etymology)
    }
}

struct UserStats: Codable {
    let dayStreak: Int
    let wordsLearned: Int
    let savedWords: Int
    
    init(dayStreak: Int = 0, wordsLearned: Int = 0, savedWords: Int = 0) {
        self.dayStreak = dayStreak
        self.wordsLearned = wordsLearned
        self.savedWords = savedWords
    }
}
