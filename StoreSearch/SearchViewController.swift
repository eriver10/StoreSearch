//
//  ViewController.swift
//  StoreSearch
//
//  Created by Grey on 9/21/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    //Reminder: static, in short practical terms, let's us instantiate with out () brackets calling.
    static let loadingCell = "LoadingCell"
    
    //This instance variable adds an array we will use to store our fake search data(Delegate extension bellow).
    
    var searchResults = [SearchResult]()
   // var searchResults = [String]()
    
    //Note: every time the user enters into a search the items in this instantiated (created) Array will be updated overwriting the last.
    var hasSearched = false
    var isLoading = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //This new struct (TableView) includes a secondary struct (CellIdentifiers) it has a constant (SearchResultCell) set to “SearchResultCell”.
    //Now, if you should ever want to change it, you can update it here and it will trickle down to anything that uses it.

    struct TableView {
        
        //A struct within a struct..
      struct CellIdentifiers {
        
          //Note: the static keyword
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
          
          /*
           Using 'static' will allow you to access it without having to instantiate it.
           For example:
           someTableThing.searchResultCell
           versus
           someTableThing().searchResultCell
           */
          
      }
    }
    

    
    //VIEWDIDLOAD\\
    override func viewDidLoad() {
        
      super.viewDidLoad()
       
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
         tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
         cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
         tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
         cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
         tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        
      /*
      tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        //Code to register 'nib' file (.nib) for use.
        //Note: it is not using the .xib extension.
      
        //changed for let(const) to var
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
      cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
      tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
      */
        
        searchBar.becomeFirstResponder()
        
        /*
         "The UINib class is used to load nibs," the book says. This code will set in motion loading the nib. Then, the book continues, it asks, "the table view to register this nib for the reuse identifier “SearchResultCell. From now on, when you call dequeueReusableCell(withIdentifier:) for the identifier “SearchResultCell”, UITableView will automatically make (or reuse) a new cell from the nib..."
         */
    }
    
    // MARK: - Helper Methods
    //Yes, we are using this function to access itunes, however, we are also including to except special characters in the search string.
    func iTunesURL(searchText: String) -> URL {
        
      let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
      let url = URL(string: urlString)
      
            return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        
      do {
        return try Data(contentsOf: url)
      } catch {
        print("Download Error: \(error.localizedDescription)")
          
        showNetworkError()
          
        return nil
      }
    }
    
    //Using JSONDecoder to convert the Json data we get back in our queries

    func parse(data: Data) -> [SearchResult] {
        
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
          ResultArray.self, from: data)
        return result.results
      } catch {
          print("JSON Error: \(error)")
          return []
      }
    }
    
    func showNetworkError() {
      
        let alert = UIAlertController(
        title: "Whoops...",
        message: "There was an error accessing the iTunes Store." +
        " Please try again.",
        preferredStyle: .alert)
      let action = UIAlertAction(
          title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
      }
    
  }
    
    
    
    

//MARK: - Search Bar Delegate

//Reminder we are reaching across a void to dictate an action.

//Adding additional inheritance, UITableViewDataSource in order fake some search results.

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Now we are working with real data.
        
        if !searchBar.text!.isEmpty {
          searchBar.resignFirstResponder()
          isLoading = true
          tableView.reloadData()

          hasSearched = true
          searchResults = []

          let queue = DispatchQueue.global()
 //Moving         let url = self.iTunesURL(searchText: searchBar.text!)
          
        //Working with async, putting request on background thread
        queue.async {
            
            //moved
            let url = self.iTunesURL(searchText: searchBar.text!)
            
            if let data = self.performStoreRequest(with: url) {
              
             self.searchResults = self.parse(data: data)
             self.searchResults.sort(by: <)
             
             /*
             The 'DispatchQueue.main.async' schedules a closure on the main queue. Then sets 'isLoading' to false then continues to reload the table view.
              */
              
             DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
              }
             
             
              return
            }
          }
        }
     }//Outside One

        
        
        
        func position(for bar: UIBarPositioning) -> UIBarPosition {
            
            .topAttached
        }
    }
    


    
    
    
    
//**EXTENSION**\\
   
    
// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if isLoading {
        return 1
    } else if !hasSearched {
        return 0
    } else if searchResults.count == 0 {
        return 1
    } else {
      return searchResults.count
    }
  }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if isLoading {
          let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
          
//***DEBUG:Something here is causing crash ERROR:****
/*
 let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
 spinner?.startAnimating()
 */
            
//Testing with ? optional
            let spinner = cell.viewWithTag(100) as? UIActivityIndicatorView
            spinner?.startAnimating()
          
            return cell
            
        } else if searchResults.count == 0 {
          return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
          let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
          let searchResult = searchResults[indexPath.row]
          cell.nameLabel.text = searchResult.name
          if searchResult.artist.isEmpty {
            cell.artistNameLabel.text = "Unknown"
          } else {
            cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
          }
            return cell
        }
      }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      
      if searchResults.count == 0 || isLoading {
        return nil
      } else {
        return indexPath
      }
    }
    
    
    
}//This is closing bracket*******
