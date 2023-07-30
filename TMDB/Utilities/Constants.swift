//
//  Constants.swift
//  Routecab-Passenger
//
//  Created by Ehtisham Badar on 18/12/2021.
//

import UIKit

class Constants {
    static var tabbarController: CustomTabBarViewController? = nil
    static let API_IMAGE_URL = "https://image.tmdb.org/t/p/original"
    static let APIKEY = "f3def453b0b712f64484da2cd0b80f8a"
}
enum ErrorCode: Int{
    case undefinedError = 1, deauthenticated, duplicate, doesNotExist,rest_error_code
    case internetError = -1009
}
enum HttpStatusCode: Int {
    case serverError = 500
    case badRequest = 400
    case forbidden = 403
    case success = 200
    case unauthorized = 401
    case timeOut = 504
}
// MyAPIHandler Error
enum APIError: Int{
    case undefinedError = 1, deauthenticated, duplicate, doesNotExist,rest_error_code
    case internetError = -1009
    case local = 0
}
enum APIKey{
    static let key = "key"
    static let site = "site"
    static let genres = "genres"
    static let overview = "overview"
    static let release_date = "release_date"
    static let backdrop_path = "backdrop_path"
    static let results = "results"
    static let poster_path = "poster_path"
    static let original_title = "original_title"
    static let apiKey = "api_key"
    static let name = "name"
    static let id = "id"
}
enum API_URLS{
    static var BASE_URL_STRING = PROD_URL_STRING
    static let PROD_URL_STRING = "https://api.themoviedb.org/3/movie/"
    static let upcomingMovies = "upcoming?api_key=\(Constants.APIKEY)"
    static func movieDetails(movieId: String) -> String{
        return movieId + "?api_key=\(Constants.APIKEY)"
    }
    static func getMovieTrailers(movieId: String) -> String{
        return movieId + "/videos" + "?api_key=\(Constants.APIKEY)"
    }
    static let getPopularMovies = "popular?api_key=\(Constants.APIKEY)"
    static func searchMovies(query: String) -> String{
        return "https://api.themoviedb.org/3/search/movie/" + "?api_key=\(Constants.APIKEY)" + "&query=\(query)"
    }
    
}
