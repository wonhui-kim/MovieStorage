//
//  BookmarkManager.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/27.
//

import Foundation

class BookmarkManager {
    
    static let shared = BookmarkManager()
    
    private var bookmarks = Set<Movie>()
    
    func insertBookmark(movie: Movie) {
        bookmarks.insert(movie)
    }
    
    func removeBookmark(movie: Movie) {
        bookmarks.remove(movie)
    }
    
    func containsBookmark(movie: Movie) -> Bool {
        return bookmarks.contains(movie)
    }
    
    func fetchBookmark() -> [Movie] {
        return Array(bookmarks)
    }
}


