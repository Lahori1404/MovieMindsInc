//
//  MoviesModel.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation
import SwiftUI

// MARK: - MoviesModel
struct MovieListModel: Decodable, Hashable, Identifiable {
    var id: MainScreenSection? = .trending
    let results: [MovieModel]
}

// MARK: - Result
struct MovieModel: Identifiable, Decodable, Hashable, Equatable {
    
    let id: Int
    let backdrop_path: String?
    let original_title, overview: String
    let release_date: String
    let original_language: String
    let vote_average: Double
    
    var imageURL: URL? {
        let baseURL = URL(string: AppConstants.imageBaseUrl)
        return baseURL?.appending(path: backdrop_path ?? "")
    }
    
    init(id: Int, backdrop_path: String, release_date: String, original_title: String, overview: String, original_language: String, vote_average: Double) {
        self.id = id
        self.backdrop_path = backdrop_path
        self.original_title = original_title
        self.overview = overview
        self.original_language = original_language
        self.release_date = release_date
        self.vote_average = vote_average
    }
}

struct MovieDetailsModel: Identifiable, Equatable {
    
    static func == (lhs: MovieDetailsModel, rhs: MovieDetailsModel) -> Bool {
        return lhs.id == rhs.id && lhs.watchlist == rhs.watchlist
    }
    
    let id: Int64
    var watchlist: String?
    var image: UIImage?
    let imageURL: URL?
    let title: String
    let overview: String
    let releaseDate: String
    let originalLanguage: String
    let rating: Double
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
