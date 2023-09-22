//
//  ViewController.swift
//  StoreSearch
//
//  Created by Grey on 9/21/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    //This instance variable adds an array we will use to store our fake search data(Delegate extension bellow).
    
    var searchResults = [SearchResult]()
   // var searchResults = [String]()
    
    //Note: every time the user enters into a search the items in this instantiated (created) Array will be updated overwriting the last.
    var hasSearched = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //VIEWDIDLOAD\\
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom:
                                                0, right: 0)
        
        //Code to register 'nib' file (.nib) for use.
        //Note: it is not using the .xib extension.
        let cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchResultCell")
        
        /*
         "The UINib class is used to load nibs," the book says. This code will set in motion loading the nib. Then, the book continues, it asks, "the table view to register this nib for the reuse identifier “SearchResultCell. From now on, when you call dequeueReusableCell(withIdentifier:) for the identifier “SearchResultCell”, UITableView will automatically make (or reuse) a new cell from the nib..."
         */
    }


    
}



//MARK: - Search Bar Delegate

//Reminder we are reaching across a void to dictate an action.

//Adding additional inheritance, UITableViewDataSource in order fake some search results.

extension SearchViewController: UISearchBarDelegate {
    
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
    searchBar.resignFirstResponder()
    searchResults = []

      if searchBar.text! != "justin time" {
      for i in 0 ... 2 {
        let searchResult = SearchResult()
        searchResult.name = String(format: "Fake Result %d for", i)
        searchResult.artistName = searchBar.text!
        searchResults.append(searchResult)
       }
     }
      
    hasSearched = true
    tableView.reloadData()
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition {
      
    .topAttached
  }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }

    
    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cellIdentifier = "SearchResultCell"
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath) as! SearchResultCell
        
        if searchResults.count == 0 {
            cell.nameLabel.text = "(Nothing found)"
            cell.artistNameLabel.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            cell.artistNameLabel.text = searchResult.artistName
        }
        
        return cell
    }
    
  /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if searchResults.count == 0 {
        return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        let searchResult = searchResults[indexPath.row]
        cell.nameLabel.text = searchResult.name
        cell.artistNameLabel.text = searchResult.artistName
        return cell
      }
    }
*/
    
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      
    if searchResults.count == 0 {
        return nil
    } else {
        return indexPath
    }
  }
}
