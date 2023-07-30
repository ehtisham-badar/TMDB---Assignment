//
//  Trailer.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import Foundation

class Trailer: NSObject, NSCoding {
    var name: String = DefaultValue.string
    var key: String = DefaultValue.string
    var site: String = DefaultValue.string
    var id: Int = DefaultValue.int
    init(_ productJSonObject: Dictionary<String, Any>?) {
        super.init()
        if(productJSonObject != nil){
            parseJsonData(productJSonObject: productJSonObject!)
        }
    }
   
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: APIKey.name) as? String ?? DefaultValue.string
        key = decoder.decodeObject(forKey: APIKey.key) as? String ?? DefaultValue.string
        site = decoder.decodeObject(forKey: APIKey.site) as? String ?? DefaultValue.string
        id = decoder.decodeObject(forKey: APIKey.id) as? Int ?? DefaultValue.int
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: APIKey.name)
        coder.encode(key, forKey: APIKey.key)
        coder.encode(site, forKey: APIKey.site)
        coder.encode(id, forKey: APIKey.id)
    }
    func parseJsonData(productJSonObject: Dictionary<String, Any>) {
        name = productJSonObject[APIKey.name] as? String ?? DefaultValue.string
        key = productJSonObject[APIKey.key] as? String ?? DefaultValue.string
        site = productJSonObject[APIKey.site] as? String ?? DefaultValue.string
        id = productJSonObject[APIKey.id] as? Int ?? DefaultValue.int
    }
}
