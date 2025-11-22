//
//  MovieDetailsViewModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation
import UIKit

class MovieDetailsViewModel: ObservableObject {
    
    var movie: MovieDetailsModel
    
    @Published var showUserInputDialogue: Bool = false
    @Published var showConfirmationDialogue: Bool = false
    @Published var showUserWatchlistSheet = false
    @Published var uiImage: UIImage?
    @Published var trailerKey: String = ""
    let infoText: String = "WatchlistSheetView.addWatchlist.infoText".localized()
    let emptyWatchlistText: String = "WatchlistSheetView.addWatchlist.emptyWatchlistMessage".localized()
    
    init(movie: MovieDetailsModel, uiImage: UIImage? = nil) {
        self.movie = movie
        self.uiImage = uiImage
    }
    
    var watchlists: [String: [Movie]] {
        let moviesFromDB = CoreDataManager.shared.fetchData()
        var categories: [String: [Movie]] = [:]
        for movie in moviesFromDB {
            let key = movie.watchlistName
            var value = categories[key] ?? []
            value.append(movie)
            categories.updateValue(value, forKey: key)
        }
        return categories
    }
    
    var watchlistNames: [String] {
        Array(watchlists.keys).sorted()
    }
    
    func loadMovieImage() {
        guard let imageURL = movie.imageURL, uiImage == nil else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.uiImage = UIImage(data: data)
            }
        }
        .resume()
    }
    
    @MainActor
    func fetchTrailerKey() async {
        do {
            let videoResponse = try await MovieMindsService.shared.getVideoResponse(movieId: String(movie.id))
            trailerKey = videoResponse.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" } )?.key ?? ""
        } catch {
            debugPrint(error)
        }
    }
    
    func addWatchlist(watchlistName: String) {
        movie.image = uiImage
        CoreDataManager.shared.deleteMovie(movieDetails: movie)
        CoreDataManager.shared.saveMovie(movie: movie,
                                         watchListName: watchlistName)
        self.showUserWatchlistSheet = false
        self.showConfirmationDialogue = true
    }
}
