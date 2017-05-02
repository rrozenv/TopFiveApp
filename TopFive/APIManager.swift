//
//  APIManager.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    static var cache = NSCache<NSString, NSData>()
    
    class func getBussinessInsiderJSON(completion: @escaping ([[String: Any]]) -> Void) {
        let urlString = "https://newsapi.org/v1/articles"
        let params = ["source": "business-insider", "sortBy": "top", "apiKey" : "\(Secrets.apiKey)"]
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { (response) in
            if let JSONdict = response.result.value as? [String: Any] {
                if let JSONarticles = JSONdict["articles"] as? [[String: Any]] {
                    completion(JSONarticles)
                }
            }
        }
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
