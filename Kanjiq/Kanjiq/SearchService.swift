//
//  SearchService.swift
//  Kanjiq
//
//  Created by Andrew Spencer on 1/30/16.
//  Copyright © 2016 Andrew Spencer. All rights reserved.
//

import UIKit

class SearchService {
    // MARK: properties
    var kanjiMeaningLookup: Dictionary<String, Set<String> >!
    var kanjiRadicalLookup: Dictionary<String, Set<String> >!
    var kanjiInfo: NSDictionary!
    
    init() {
        if let kanjiLookupJson = getJSONAssetAsNSDictionary(assetName: "kanjiLookup") {
            if let meaningsTable = kanjiLookupJson["meaningTable"] {
                kanjiMeaningLookup = [:]
                for (key, value) in meaningsTable as! NSDictionary {
                    kanjiMeaningLookup[key as! String] = Set(value as! [String])
                }
            }
            
            if let radicalTable = kanjiLookupJson["radicalTable"] {
                kanjiRadicalLookup = [:]
                for (key, value) in radicalTable as! NSDictionary {
                    kanjiRadicalLookup[key as! String] = Set(value as! [String])
                }
            }
        }
        
        if let kanjiInfoJson = getJSONAssetAsNSDictionary(assetName: "kanji") {
           kanjiInfo = kanjiInfoJson
        }
    }
    
    
    private func getJSONAssetAsNSDictionary(assetName name:String) -> NSDictionary? {
        if let asset = NSDataAsset(name:name) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(asset.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            } catch {
            }
        }
        
        return nil
    }
    
    
    private func tokenize(string s: String) -> [String] {
        var tokens = [String]()
        var currentToken = ""
        for c in s.lowercaseString.characters {
            if (c == " ") {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
            } else if ("a"..."z").contains(c) {
                currentToken.append(c)
            } else {
                // Invalid input character
                return []
            }
        }
        
        if !currentToken.isEmpty {
            tokens.append(currentToken)
        }
        
        return tokens
    }
    
    private func getRadicals(kanji k: String) -> [String]? {
        if let kanjiEntry = kanjiInfo[k] as? NSDictionary {
            if let radicalString = kanjiEntry["radical"] as? String {
                return radicalString.characters.map { String($0) }
            }
        }
        
        return []
    }
    
    private func getStrokes(kanji k: String) -> Int {
        if let kanjiEntry = kanjiInfo[k] as? NSDictionary {
            if let strokes = kanjiEntry["strokes"] as? Int {
                return strokes
            }
        }
        
        return -1
    }
    
    private func getMatches(token t: String) -> Set<String> {
        var results = Set<String>()
        
        // For meaning matches, look for the same combination of radicals in other
        // kanji so that we can identify complex primitives
        if let meaningMatches = kanjiMeaningLookup[t] {
            results.unionInPlace(meaningMatches)
            for match in meaningMatches {
                if let kanjiRadicals = getRadicals(kanji:match) {
                    results.unionInPlace(searchKanji(tokens:kanjiRadicals))
                }
            }
        }
        
        if let radicalMatches = kanjiRadicalLookup[t] {
            results.unionInPlace(radicalMatches)
        }
        
        return results
    }
    
    
    private func searchKanji(tokens tokens: [String]) -> Set<String> {
        var results = getMatches(token: tokens[0])
        for token in tokens[1..<tokens.count] {
            results.intersectInPlace(getMatches(token: token))
        }
        
        return results
    }
    
    
    func searchKanji(queryString query: String) -> [String] {
        let tokens = tokenize(string:query)
        if tokens.isEmpty {
            return []
        }
        
        return Array(searchKanji(tokens:tokens)).sort { getStrokes(kanji: $0) < getStrokes(kanji: $1) }
    }
}

