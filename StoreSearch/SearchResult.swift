//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Grey on 9/22/23.
//

import Foundation
import UIKit

class ResultArray: Codable {
    
    var resultCount = 0
    var results = [SearchResult]()
}



class SearchResult: Codable, CustomStringConvertible {
    
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    /*
     Take note of the '??' nil-coalescing operator:
     \(artistName ?? "None"
     If when unwrapping 'artistName' swift does not find a value it will fail-over to "None"
     
     */
    

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
          switch kind {
          case "album":
            return NSLocalizedString(
              "Album",
              comment: "Localized kind: Album")
          case "audiobook":
            return NSLocalizedString(
              "Audio Book",
              comment: "Localized kind: Audio Book")
          case "book":
            return NSLocalizedString(
        "Book",
              comment: "Localized kind: Book")
          case "ebook":
            return NSLocalizedString(
              "E-Book",
              comment: "Localized kind: E-Book")
          case "feature-movie":
            return NSLocalizedString(
        "Movie",
              comment: "Localized kind: Feature Movie")
          case "music-video":
            return NSLocalizedString(
              "Music Video",
              comment: "Localized kind: Music Video")
          case "podcast":
            return NSLocalizedString(
        "Podcast",
              comment: "Localized kind: Podcast")
          case "software":
            return NSLocalizedString(
              "App",
              comment: "Localized kind: Software")
          case "song":
            return NSLocalizedString(
              "Song",
              comment: "Localized kind: Song")
          case "tv-episode":
            return NSLocalizedString(
        "TV Episode",
              comment: "Localized kind: TV Episode")
          default:
        return kind }
        }

    var artist: String {
      return artistName ?? ""
    }

    var description: String {
      return "\nResult - Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
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

}//Closes the SearchResult Class

















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
