//
//  CoreDataManger.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    private let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataManager()
    
    init() {
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "MovieModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveMovie(movie: MovieDetailsModel, watchListName: String) {
        let movieContext = persistentContainer.viewContext
        let newMovie = Movie(context: movieContext)
        newMovie.id = movie.id
        newMovie.name = movie.title
        newMovie.overview = movie.overview
        newMovie.image = movie.image
        newMovie.rating = movie.rating
        newMovie.language = movie.originalLanguage
        newMovie.watchlistName = watchListName
        newMovie.releaseDate = movie.releaseDate
        
        do {
            try movieContext.save()
        } catch {
            debugPrint("error saving movie: \(error.localizedDescription)")
        }
    }
    
    func deleteMovie(movieDetails: MovieDetailsModel) {
        let movies = fetchData()
        guard !movies.isEmpty, let movie = movies.first(where: { $0.id == movieDetails.id && $0.watchlistName == movieDetails.watchlist }) else { return }
        
        let movieContext = persistentContainer.viewContext

        movieContext.delete(movie)
        
        do {
            try movieContext.save()
        } catch {
            debugPrint("error deleting movie: \(error.localizedDescription)")
        }
    }
    
    func fetchData() -> [Movie] {
        let request: NSFetchRequest<Movie> = NSFetchRequest(entityName: "Movie")
        do {
            let movies: [Movie] = try persistentContainer.viewContext.fetch(request)
            return movies
        } catch {
            debugPrint(error.localizedDescription)
        }
        return []
    }
}
