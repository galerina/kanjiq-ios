//
//  SearchCollectionViewController.swift
//  Kanjiq
//
//  Created by Andrew Spencer on 1/30/16.
//  Copyright © 2016 Andrew Spencer. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    // MARK: properties
    var matchingKanji: [String]!
    var matchingWords: [String]!
    var searchService: SearchService!
    var searchActive: Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchService = SearchService()
        searchBar.delegate = self
        collectionView.dataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if matchingKanji != nil {
            return matchingKanji.count
        } else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SearchResultCollectionViewCell
        cell.searchResultText?.text = matchingKanji[indexPath.row]
        return cell
    }

    
    // MARK: UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        matchingKanji?.removeAll()
        
        let query = searchBar.text?.lowercaseString
        if !(query ?? "").isEmpty {
            matchingKanji = searchService.searchKanji(queryString:query!)
        }
    
        collectionView.reloadData()
    }
}
