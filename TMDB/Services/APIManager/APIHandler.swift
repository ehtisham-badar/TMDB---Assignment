//
//  APIHandler.swift
//  TMDB
//
//  Created by Ehtisham Badar on 04/03/2022.
//

import Foundation
import UIKit
import SystemConfiguration
class APIHandler: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate{
    
    //MARK: -Properties
    static let shared = APIHandler()
    let printDebugResponses = true
    var appVersion: String?{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String?{
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    //MARK: -Setup
    override init(){
        // Do any additional setup before init
        super.init()
        
    }
    
    private func resumeDataTaskWith(request: NSMutableURLRequest,onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any?) -> Swift.Void){
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == HttpStatusCode.timeOut.rawValue {
                    print("Status code: (\(httpResponse.statusCode))")
                    onError("Something Went Wrong", ErrorCode.undefinedError.rawValue, nil)
                    return
                }
                if error != nil{
                    onError((error?.localizedDescription)!, (error! as NSError).code, nil)
                    return
                }
                
                do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    if let jsonDict = json as? NSDictionary{
                        if let error = jsonDict.object(forKey: "") as? NSNumber{
                            
                            
                            self.printFailerAPILogs(requestURL: (request.url?.absoluteString)!, requestParams: request.httpBody!, requestResponse: jsonDict as Any)
                            onError("Something Went Wrong",error.intValue, jsonDict)
                            return
                        
                        }
                        
                    }
                    
                    onSuccess(json)
                    if(self.printDebugResponses && request.httpBody != nil){
                        self.printFailerAPILogs(requestURL: (request.url?.absoluteString)!, requestParams: request.httpBody!, requestResponse: json as Any)
                    }
                    
                } catch let error as NSError {
                    onError(error.localizedDescription, error.code, nil)
                    self.printFailerAPILogs(requestURL: (request.url?.absoluteString)!, requestParams: request.httpBody!, requestResponse: error as Any)
                }
            }
            
        }
        task.resume()
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func printFailerAPILogs(requestURL: String, requestParams: Data, requestResponse: Any){
        
        print("requestURL: \(requestURL)")
        do{
            let params = try JSONSerialization.jsonObject(with: requestParams, options: [])
            print("requestParams: \(String(data: try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted), encoding: .utf8 )!)")
            
        } catch let error as NSError{
            print("requestParams: \(error)")
            
        }
        print("requestResponse: \(requestResponse)")
        
        
    }
    
    private func getRequest(urlString: String,onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger,_ response: Any?) -> Swift.Void){
        
        let url = NSURL(string: API_URLS.BASE_URL_STRING+urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        self.resumeDataTaskWith(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    private func postRequest(urlString: String, params: Dictionary<String, Any>, onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        
        var params = params
        params["api_key"] = Constants.APIKEY
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            
            let url = NSURL(string: API_URLS.BASE_URL_STRING+urlString)!
            let request = NSMutableURLRequest(url: url as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            self.resumeDataTaskWith(request: request, onSuccess: onSuccess, onError: onError)
            
        }
    }
    private func postRequestSearch(urlString: String, params: Dictionary<String, Any>, onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        
        var params = params
        params["api_key"] = Constants.APIKEY
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            
            let url = NSURL(string: urlString)!
            let request = NSMutableURLRequest(url: url as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            self.resumeDataTaskWith(request: request, onSuccess: onSuccess, onError: onError)
            
        }
    }
    func showUpcomingMovies(onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        self.postRequest(urlString: API_URLS.upcomingMovies,params: [:], onSuccess: onSuccess, onError: onError)
    }
    func showMovieDetail(movieId: String, onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        
        self.getRequest(urlString: API_URLS.movieDetails(movieId: movieId), onSuccess: onSuccess, onError: onError)
    }
    func getTrailers(movieId: String, onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        
        self.getRequest(urlString: API_URLS.getMovieTrailers(movieId: movieId), onSuccess: onSuccess, onError: onError)
    }
    func showPopularMovies(onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        self.postRequest(urlString: API_URLS.getPopularMovies,params: [:], onSuccess: onSuccess, onError: onError)
    }
    func searchMovies(query: String, onSuccess: @escaping (_ response: Any) -> Swift.Void, onError: @escaping (_ message: String,_ code: NSInteger, _ response: Any) -> Swift.Void){
        self.postRequestSearch(urlString: API_URLS.searchMovies(query: query),params: [:], onSuccess: onSuccess, onError: onError)
    }
}

