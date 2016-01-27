//
//  TableViewController.swift
//  Kanjiq
//
//  Created by Andrew Spencer on 1/27/16.
//  Copyright © 2016 Andrew Spencer. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    // MARK: properties
    var kanjiLookup: NSDictionary!
    var matchingKanji: [String]!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search controller
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        if let asset = NSDataAsset(name:"kanjiLookup") {
            do {
                try kanjiLookup = NSJSONSerialization.JSONObjectWithData(asset.data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                if kanjiLookup != nil
                {
                    print("Success")
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

    // MARK: UISearchController
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        matchingKanji?.removeAll()
        
        let query = searchController.searchBar.text?.lowercaseString
        if !(query ?? "").isEmpty {
            if let meanings = kanjiLookup["meaningTable"] {
                if let results = meanings[query!] as? [String] {
                    matchingKanji = results
                }
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingKanji != nil {
            return matchingKanji.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("queryResult", forIndexPath: indexPath) as! KanjiTableViewCell
        cell.kanjiTextView?.text = matchingKanji[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView,
        shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("Showing menu")
        return true
    }
}