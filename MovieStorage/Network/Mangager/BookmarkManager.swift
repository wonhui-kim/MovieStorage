//
//  BookmarkManager.swift
//  MovieStorage
//
//  Created by kim-wonhui on 2022/12/27.
//

import Foundation

class BookmarkManager {
    
    static let shared = BookmarkManager()
    
    private let coreDataManager = CoreDataManager.shared
    
    func insertBookmark(movie: Movie) {
        coreDataManager.createMovie(movie: movie)
    }
    
    func removeBookmark(movie: Movie) {
        coreDataManager.deleteMovie(movie: movie)
    }
    
    func containsBookmark(movie: Movie) -> Bool {
        let bookmarks = coreDataManager.fetchMovie()
        return bookmarks.contains(movie)
    }
    
    func fetchBookmark() -> [Movie] {
        return coreDataManager.fetchMovie()
    }
}


