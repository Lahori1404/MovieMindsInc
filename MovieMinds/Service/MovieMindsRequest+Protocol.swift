//
//  MovieMindsRequest+Protocol.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation

protocol MovieMindsRequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var urlParams: [String: String]? { get }
    var requestType: RequestType { get }
}

extension MovieMindsRequestProtocol {
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if let param = urlParams, !param.isEmpty {
            components.queryItems = param.map {
                URLQueryItem(name: $0, value: $1)
            }
        }

        guard let url = components.url
        else { throw RESTRequestError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if let headers = headers, !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        urlRequest.setValue("application/json",
                            forHTTPHeaderField: "Content-Type")
        
        urlRequest.timeoutInterval = 3
        
        if let params = params, !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: params)
        }
        return urlRequest
    }
}

enum MovieMindsRequests: MovieMindsRequestProtocol {
    
    case getTrendingMoviesByDay
    case getNowPlayingMovies
    case getTopRatedMovies
    case getPopularMovies
    case getSearchResponse(_ query: String)
    case getVideoResponse(_ movieId: String)

    private enum Constants {
        static let getTrendingMoviesByDayPath = "/3/trending/movie/day"
        static let getNowPlayingMoviesPath = "/3/movie/now_playing"
        static let getTopRatedMoviesPath = "/3/movie/top_rated"
        static let getPopularMoviesPath = "/3/movie/popular"
        static let getSearchResponse = "/3/search/movie"
        static let getVideoResponse = "/3/movie/"
        static let apiHeaderKey = "api_key"
    }

    var host: String {
        switch self {
        case .getTrendingMoviesByDay, .getNowPlayingMovies, .getTopRatedMovies, .getPopularMovies, .getSearchResponse, .getVideoResponse:
            return AppConstants.mainBaseUrl
        }
    }

    var path: String {
        switch self {
        case .getTrendingMoviesByDay:
            Constants.getTrendingMoviesByDayPath
        case .getNowPlayingMovies:
            Constants.getNowPlayingMoviesPath
        case .getTopRatedMovies:
            Constants.getTopRatedMoviesPath
        case .getPopularMovies:
            Constants.getPopularMoviesPath
        case .getSearchResponse:
            Constants.getSearchResponse
        case .getVideoResponse(let movieId):
            "\(Constants.getVideoResponse)\(movieId)/videos"
        }
    }

    var headers: [String: String]? {
        return ["Authorization": AppConstants.apiKey]
    }

    var params: [String: Any]? {
        nil
    }

    var urlParams: [String: String]? {
        switch self {
        case .getTrendingMoviesByDay, .getNowPlayingMovies, .getTopRatedMovies, .getPopularMovies, .getVideoResponse:
            return [:]
        case .getSearchResponse(let query):
            return ["Authorization": AppConstants.apiKey, "query": query]
            
        }
    }

    var requestType: RequestType {
        .get
    }
}

enum RESTRequestError: Error {
    case invalidURL
    case invalidServerResponse
    case decode
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown
    case notConnectedToInternet

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

enum RequestType: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


