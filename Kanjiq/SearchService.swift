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
        if let asset = NSDataAsset(name:"kanjiLookup") {
            do {
                let kanjiLookupJson = try NSJSONSerialization.JSONObjectWithData(asset.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                if kanjiLookupJson != nil
                {
                    print("Success")
                    if let meaningsTable = kanjiLookupJson!["meaningTable"] {
                        kanjiMeaningLookup = [:]
                        for (key, value) in meaningsTable as! NSDictionary {
                            kanjiMeaningLookup[key as! String] = Set(value as! [String])
                        }
                    }
                    
                    if let radicalTable = kanjiLookupJson!["radicalTable"] {
                        kanjiRadicalLookup = [:]
                        for (key, value) in radicalTable as! NSDictionary {
                            kanjiRadicalLookup[key as! String] = Set(value as! [String])
                        }
                    }
                } else {
                    print("JSON Failed")
                }
            } catch {
                print("Reading file failed")
            }
        } else {
            print("Failed path")
        }
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
    
    private func getMatches(token t: String) -> Set<String> {
        if let results = kanjiRadicalLookup[t] {
            return results
        } else {
            return []
        }
    }
    
    
    func search(queryString query: String) -> [String] {
        let tokens = tokenize(string:query)
        print(tokens)
        if tokens.isEmpty {
            return []
        }
        
        var results = getMatches(token: tokens[0])
        for token in tokens[1..<tokens.count] {
            results.intersectInPlace(getMatches(token: token))
        }
        
        return Array(results)
    }
}

