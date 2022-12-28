//
//  CoreDataManager.swift
//  CoreDataTest
//
//  Created by kim-wonhui on 2022/12/28.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func createMovie(movie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let bookmarkEntity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context) else { return }
        
        let managedObject = NSManagedObject(entity: bookmarkEntity, insertInto: context)
        managedObject.setValue(movie.poster, forKey: "poster")
        managedObject.setValue(movie.title, forKey: "title")
        managedObject.setValue(movie.imdbID, forKey: "imdbID")
        managedObject.setValue(movie.year, forKey: "year")
        managedObject.setValue(movie.type, forKey: "type")
        
        appDelegate.saveContext()
    }
    
    func fetchModel() -> [Bookmark] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let request = Bookmark.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func fetchMovie() -> [Movie] {
        var movies = [Movie]()
        let fetchResults = fetchModel()
        
        for result in fetchResults {
            if let title = result.title,
               let year = result.year,
               let imdbID = result.imdbID,
               let type = result.type,
               let poster = result.poster {
                let movie = Movie(title: title, year: year, imdbID: imdbID, type: type, poster: poster)
                movies.append(movie)
            }
        }
        
        return movies
    }
    
    func resetOrder(movies: [Movie]) {
        deleteAllMovie()
        
        for movie in movies {
            createMovie(movie: movie)
        }
    }
    
    func deleteMovie(movie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchResults = fetchModel()
        
        let managedObject = fetchResults.filter { $0.imdbID == movie.imdbID }[0]
        context.delete(managedObject)
        
        appDelegate.saveContext()
    }
    
    func deleteAllMovie() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchResults = fetchModel()
        
        for result in fetchResults {
            context.delete(result)
        }
        appDelegate.saveContext()
    }
}
