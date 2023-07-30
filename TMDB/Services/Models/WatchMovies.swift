//
//  WatchMovies.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import Foundation

class WatchMovies: NSObject, NSCoding {
    var original_title: String = DefaultValue.string
    var poster_path: String = DefaultValue.string
    var backdrop_path: String = DefaultValue.string
    var overview: String = DefaultValue.string
    var release_date: String = DefaultValue.string
    var id: Int = DefaultValue.int
    var genresList: Array<Genres> = Array<Genres>()
    init(_ productJSonObject: Dictionary<String, Any>?) {
        super.init()
        if(productJSonObject != nil){
            parseJsonData(productJSonObject: productJSonObject!)
        }
    }
   
    required init(coder decoder: NSCoder) {
        original_title = decoder.decodeObject(forKey: APIKey.original_title) as? String ?? DefaultValue.string
        poster_path = decoder.decodeObject(forKey: APIKey.poster_path) as? String ?? DefaultValue.string
        backdrop_path = decoder.decodeObject(forKey: APIKey.backdrop_path) as? String ?? DefaultValue.string
        overview = decoder.decodeObject(forKey: APIKey.overview) as? String ?? DefaultValue.string
        release_date = decoder.decodeObject(forKey: APIKey.release_date) as? String ?? DefaultValue.string
        id = decoder.decodeObject(forKey: APIKey.id) as? Int ?? DefaultValue.int
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(original_title, forKey: APIKey.original_title)
        coder.encode(poster_path, forKey: APIKey.poster_path)
        coder.encode(backdrop_path, forKey: APIKey.backdrop_path)
        coder.encode(overview, forKey: APIKey.overview)
        coder.encode(release_date, forKey: APIKey.release_date)
        coder.encode(id, forKey: APIKey.id)
    }
    func parseJsonData(productJSonObject: Dictionary<String, Any>) {
        original_title = productJSonObject[APIKey.original_title] as? String ?? DefaultValue.string
        poster_path = productJSonObject[APIKey.poster_path] as? String ?? DefaultValue.string
        backdrop_path = productJSonObject[APIKey.backdrop_path] as? String ?? DefaultValue.string
        overview = productJSonObject[APIKey.overview] as? String ?? DefaultValue.string
        release_date = productJSonObject[APIKey.release_date] as? String ?? DefaultValue.string
        id = productJSonObject[APIKey.id] as? Int ?? DefaultValue.int
        let genresList = (productJSonObject[APIKey.genres] as? Array<Dictionary<String, Any>>) ?? [[:]]
        self.genresList.removeAll()
        for case let genrelist in genresList{
            let genre =  Genres(genrelist)
            self.genresList.append(genre)
        }
    }
}


class Genres: NSObject, NSCoding {
    var name: String = DefaultValue.string
    var id: Int = DefaultValue.int
    
    init(_ productJSonObject: Dictionary<String, Any>?) {
        super.init()
        if(productJSonObject != nil){
            parseJsonData(productJSonObject: productJSonObject!)
        }
    }
   
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: APIKey.name) as? String ?? DefaultValue.string
        id = decoder.decodeObject(forKey: APIKey.id) as? Int ?? DefaultValue.int
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: APIKey.name)
        coder.encode(id, forKey: APIKey.id)
    }
    func parseJsonData(productJSonObject: Dictionary<String, Any>) {
        name = productJSonObject[APIKey.name] as? String ?? DefaultValue.string
        id = productJSonObject[APIKey.id] as? Int ?? DefaultValue.int
    }
}
