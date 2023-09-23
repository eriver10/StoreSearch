//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Grey on 9/22/23.
//

import Foundation

class ResultArray: Codable {
    
    var resultCount = 0
    var results = [SearchResult]()
}



class SearchResult: Codable, CustomStringConvertible {
    
    var artistName: String? = ""
    var trackName: String? = ""
    
    var kind: String? = ""
    var description: String {
        
        return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
    }
    /*
     Take note of the '??' nil-coalescing operator:
     \(artistName ?? "None"
     If when unwrapping 'artistName' swift does not find a value it will fail-over to "None"
     
     */
    var trackPrice: Double? = 0.0
    var currency = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    //var trackViewUrl: String? = ""
    var primaryGenreName = ""
    var imageSmall = ""
    var imageLarge = ""
    //var storeURL: String? = ""
    //var genre = ""
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    var name: String {
        
      return trackName ?? collectionName ?? ""
    }
    
    var storeURL: String {
      return trackViewUrl ?? collectionViewUrl ?? ""
    }
    var price: Double {
      return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    
    var type: String {
        
      let kind = self.kind ?? "audiobook"
        
      //Swift's way of doing Switch/Case is neat and clean no breaks or ; in the way!
      switch kind {
          case "album": return "Album"
          case "audiobook": return "Audio Book"
          case "book": return "Book"
          case "ebook": return "E-Book"
          case "feature-movie": return "Movie"
          case "music-video": return "Music Video"
          case "podcast": return "Podcast"
          case "software": return "App"
          case "song": return "Song"
          case "tv-episode": return "TV Episode"
          default: break
          }
        
            return "Unknown"
    }
    
    var artist: String {
        return artistName ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
          case imageLarge = "artworkUrl100"
          case itemGenre = "primaryGenreName"
          case bookGenre = "genres"
          case itemPrice = "price"
          case kind, artistName, currency
          case trackName, trackPrice, trackViewUrl
          case collectionName, collectionViewUrl, collectionPrice
    }
}


//Placed outside the class\\
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name)
== .orderedAscending
}





/*
 
 //Operator Overloading\\
 
  
 
//Placed outside the class\\
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name)
== .orderedAscending
}

//A shorter way: searchResults.sort { $0 < $1 }
//An even shorter way: searchResults.sort(by: <)
 
 
    This unusual Swift feature takes standard math and logical operators for instance, +,-,*,/, etc. and <,>, ==, etc. and associates them with objects.

And, according to the text, "...comes in very handy for sorting," as we shall see demonstrated in this code.
 
 Above, is a function outside the class named < (less than). That's right a function with a symbol as a name.

    Note: it uses the similar code as the in the previous closure.
 
 Its overloading process is the same as you may have seen before in standard overloading used in working logic (if/else etc.). In this case, it determines a true if the first one should come before the second, and a false the other way around. There fore, sorting our search results. The book states, "using the < operator makes it very clear that you’re sorting the items from the array in ascending order," as shown in the following example:
 
 searchResultA.name = "Waltz for Debby"
 searchResultB.name = "Autumn Leaves"
 searchResultA < searchResultB  // false
 searchResultB < searchResultA  // true
 */
