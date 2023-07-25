//
//  TextChecker.swift
//  
//
//  Created by Илья Шаповалов on 25.07.2023.
//

import Foundation
import UIKit

public struct TextChecker {
    public static func check(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        
        return misspelledRange.location == NSNotFound
    }
}
