//
//  APIManager.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

final class APIManager {

    static var cache = NSCache<NSString, NSData>()
    static let baseURL = "https://newsapi.org/v1/articles"
    
    class func getRequestFor(_ source: Source, completion: @escaping (APIResponse) -> Void) {
        Alamofire.request(baseURL, method: .get, parameters: source.getParameters()).responseJSON { (response) in
            if let JSON = response.result.value as? JSON {
                completion(.success(JSON))
            }
        }
    }
    
    //Networking without Alamofire
    class func getRequest(_ source: Source, completion: @escaping (APIResponse) -> Void) {
        guard let url = URL(string: baseURL) else { completion(.badURL("Invalid URL")); return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else { print("couldn't get data"); return }
            if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let JSON = dict?["articles"] as? JSON {
                    completion(.success(JSON))
                } else { completion(.badJSONRequest("Bad JSON Request")) }
            } else { completion(.badJSONSerialization("Could not serialize JSON")) }
        }).resume()
    }

    class func download(url: URL, completion: @escaping (Data) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let imageData = data {
                completion(imageData)
            }
        }.resume()
    }
    
    class func checkForImage(name: String, completion: (Bool, Data?) -> ()) {
        let nsname = NSString(string: name)
        if let nsimageData = APIManager.cache.object(forKey: nsname) {
            completion(true, nsimageData as Data)
        } else {
            completion(false, nil)
        }
    }
    
}

extension UIImageView {
    
    func setImage(urlString:String) {
        APIManager.checkForImage(name: urlString) { (success, data) in
            if success {
                guard let data = data else { return }
                self.image = UIImage(data: data)
            } else {
                guard let url = URL(string: urlString) else { return }
                APIManager.download(url: url) { (data) in
                    APIManager.cache.setObject(NSData(data: data), forKey: NSString(string: urlString))
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}
