//
//  WordShareHelper.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 30/01/26.
//

import Foundation

enum WordShareHelper {
    /// Returns the formatted share text for a word. Use with ActivityViewController (shareItems = [WordShareHelper.shareText(for: word)]).
    static func shareText(for word: WordOfTheDay) -> String {
        """
        Word of the Day: \(word.word)
        (\(word.partOfSpeech))
        
        Meaning: \(word.meaning)
        
        Example: \(word.example)
        
        Check it out: \(word.sourceUrl)
        """
    }
}
