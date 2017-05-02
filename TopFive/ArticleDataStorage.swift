//
//  ArticleDataStorage.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation

class ArticleDataStorage {
    
    static let articleDataStore = ArticleDataStorage()
    
    private init () { }
    
    var allArticles = [Article]()
    
    func createAllArticles(completion: @escaping (Bool) -> Void) {
        
        self.allArticles.removeAll()
        
        APIManager.getBussinessInsiderJSON { (JSONArray) in
            
            for articleDict in JSONArray {
                let article = Article(dict: articleDict)
                guard article.publishedDate != nil else { continue }
                self.allArticles.append(article)
            }
            
            if !self.allArticles.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
            
        }
        
    }

}
