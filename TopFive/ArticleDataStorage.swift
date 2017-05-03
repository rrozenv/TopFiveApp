//
//  ArticleDataStorage.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation

enum Source {
    case businessInsider
    case buzzFeed
    case espn
    
    func getParameters() -> [String: String] {
        switch self {
        case .businessInsider:
            return [
                "source": "business-insider",
                "sortBy": "top",
                "apiKey": "\(Secrets.apiKey)"
            ]
        case .buzzFeed:
            return [
                "source": "buzzfeed",
                "sortBy": "top",
                "apiKey": "\(Secrets.apiKey)"
            ]
        case .espn:
            return [
                "source": "espn",
                "sortBy": "top",
                "apiKey": "\(Secrets.apiKey)"
            ]
        }
    }
}

final class ArticleDataStorage {
    static let articleDataStore = ArticleDataStorage()
    var allArticles = [Article]()
    private init () { }
    
    func createArticlesFor(_ source: [Source], completion: @escaping (Bool) -> Void) {
        source.forEach { (source) in
            APIManager.getRequestFor(source) { [weak self] (APIResponse) in
                self?.checkAPIResponse(APIResponse) { (isSuccess) in
                    if isSuccess {
                        completion(true)
                    }
                }
            }
        }
    }
    
    private func checkAPIResponse(_ APIResponse: APIResponse, completion: (Bool) -> Void) {
        switch APIResponse {
        case .success(let JSON):
            JSON.forEach({ (dict) in
                let article = Article(dict: dict)
                if article.publishedDate != nil {
                   self.allArticles.append(article)
                }
            })
            !self.allArticles.isEmpty ? completion(true) : completion(false)
        case .badJSONRequest(_):
            completion(false)
        default:
            completion(false)
        }
    }
    
}
