//
//  MainScreenViewModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation
import UIKit
import Combine

class MainScreenViewModel: ObservableObject {
    
    @Published var moviesList = [MovieListModel]()
    @Published var movieSearchList = [MovieDetailsModel]()
    @Published var setupComplete: LoadState = .loading
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    @Published var hasSearchStarted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates() // Prevents duplicate values from being processed
            .sink { [weak self] newText in
                self?.debouncedSearchText = newText
                Task {
                    await self?.querySearch(newText)
                }
            }
            .store(in: &cancellables)
    }
    
    var watchlists: [MovieDetailsModel] {
        let moviesFromDB = CoreDataManager.shared.fetchData()
        let movies: [MovieDetailsModel] = moviesFromDB.compactMap { MovieDetailsModel(id: $0.id,
                                                                                      watchlist: $0.watchlistName,
                                                                                      image: $0.image,
                                                                                      imageURL: nil,
                                                                                      title: $0.name,
                                                                                      overview: $0.overview,
                                                                                      releaseDate: $0.releaseDate,
                                                                                      originalLanguage: $0.language,
                                                                                      rating: $0.rating) }
        return movies
    }
        
    @MainActor
    func setupMainScreen() async {
        async let fetchTrendingMoviesByDay = MovieMindsService.shared.getMoviesData(sectionType: .trending)
        async let fetchPopularMovies = MovieMindsService.shared.getMoviesData(sectionType: .popular)
        async let fetchNowPlayingMovies = MovieMindsService.shared.getMoviesData(sectionType: .nowPlaying)
        async let fetchTopRatedMovies = MovieMindsService.shared.getMoviesData(sectionType: .topRated)
        do {
            let movieSectionLists = try await [fetchTrendingMoviesByDay, fetchPopularMovies, fetchNowPlayingMovies, fetchTopRatedMovies]
            moviesList = movieSectionLists
            setupComplete = .success
        } catch {
            debugPrint("Some Error")
            setupComplete = .failure
        }
    }
    
    func setUpMovieDetailsModel(_ movies: MovieListModel) -> [MovieDetailsModel] {
        movies.results.compactMap { MovieDetailsModel(id: Int64($0.id),
                                                      image: nil,
                                                      imageURL: $0.imageURL,
                                              title: $0.original_title,
                                              overview: $0.overview,
                                              releaseDate: $0.release_date,
                                              originalLanguage: $0.original_language,
                                              rating: $0.vote_average) }
    }
    
    @MainActor
    func querySearch(_ text: String) async {
        guard text.count > 2 else {
            if text.count == 0 {
                movieSearchList.removeAll()
            }
            return
        }
        
        let queryText = text.replacingOccurrences(of: " ", with: "+")
        
        do {
            let moviesList = try await MovieMindsService.shared.getSearchResponse(searchText: queryText)
            movieSearchList = setUpMovieDetailsModel(moviesList)
        } catch {
            debugPrint(error)
        }
    }
}

public enum LoadState {
    case loading
    case success
    case failure
}

public enum MainScreenSection: Decodable, Encodable, Equatable, Hashable {
    case trending
    case nowPlaying
    case popular
    case topRated
    case yourWatchlists
    case watchlist(_ name: String)
    
    
    var sectionName: String {
        switch self {
        case .trending:
            return "Trending"
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .watchlist(let name):
            return name
        case .yourWatchlists:
            return "Your Watchlists"
        }
    }
}

public enum FilterType {
    case reset
    case filter
}
