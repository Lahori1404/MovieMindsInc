//
//  MovieMindsService.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation

class MovieMindsService {
    
    static let shared = MovieMindsService()
    
    func getMoviesData(sectionType: MainScreenSection) async throws -> MovieListModel {
        let request = getServiceRequest(sectionType: sectionType)
        var result = try await RESTRequestService.run(request,
                                                      responseModel: MovieListModel.self)
        result.id = sectionType
        return result
    }
    
    func getSearchResponse(searchText: String) async throws -> MovieListModel {
        let request = MovieMindsRequests.getSearchResponse(searchText)
        let result = try await RESTRequestService.run(request,
                                                      responseModel: MovieListModel.self)
        return result
    }
    
    func getVideoResponse(movieId: String) async throws -> VideoResponse {
        let request = MovieMindsRequests.getVideoResponse(movieId)
        let result = try await RESTRequestService.run(request,
                                                      responseModel: VideoResponse.self)
        return result
    }
    
    func getServiceRequest(sectionType: MainScreenSection) -> MovieMindsRequests {
        switch sectionType {
        case .trending:
            return MovieMindsRequests.getTrendingMoviesByDay
        case .nowPlaying:
            return MovieMindsRequests.getNowPlayingMovies
        case .popular:
            return MovieMindsRequests.getPopularMovies
        case .topRated:
            return MovieMindsRequests.getTopRatedMovies
        default:
            return MovieMindsRequests.getTrendingMoviesByDay
        }
    }
}
