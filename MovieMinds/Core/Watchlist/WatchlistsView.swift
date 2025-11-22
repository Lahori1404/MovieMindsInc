//
//  WatchlistsView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct WatchlistsView: View {
    
    let movies: [MovieDetailsModel]
    var watchlists: [String: [MovieDetailsModel]] = [:]
    
    init(movies: [MovieDetailsModel]) {
        self.movies = movies
        for movie in movies {
            watchlists[movie.watchlist ?? "Untitled", default: []].append(movie)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
                ForEach(watchlists.keys.sorted(), id: \.self) { watchlist in
                    if let watchlistMovies = watchlists[watchlist] {
                        MoviesHorizontalScrollSectionView(movies: watchlistMovies,
                                                          sectionType: .watchlist(watchlist))
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}

