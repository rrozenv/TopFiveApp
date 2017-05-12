//
//  ArticleDataStorage.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation

enum Source: String  {
    case businessInsider = "#businessinsider"
    case buzzFeed = "#buzzfeed"
    case espn = "#espn"
    case techCrunch = "#techcrunch"
    
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
        case .techCrunch:
            return [
                "source": "techcrunch",
                "sortBy": "top",
                "apiKey": "\(Secrets.apiKey)"
            ]
        }
    }
    
    func getCategoryLabel() -> String {
        switch self {
        case .businessInsider:
            return "#businessinsider"
        case .buzzFeed:
            return "#buzzfeed"
        case .espn:
            return "#espn"
        case .techCrunch:
            return "#techcrunch"
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
                    isSuccess ? completion(true) : completion(false)
                }
            }
        }
    }
    
    private func checkAPIResponse(_ APIResponse: APIResponse, completion: (Bool) -> Void) {
        switch APIResponse {
        case .success(let JSON):
            guard let source = JSON["source"] as? String else { completion(false); return }
            guard let articlesDict = JSON["articles"] as? [[String: Any]] else { completion(false); return }
            for article in articlesDict {
                if let article = Article(source: source, dict: article) {
                    self.allArticles.append(article)
                }
            }
            !self.allArticles.isEmpty ? completion(true) : completion(false)
        case .badJSONRequest(_):
            completion(false)
        default:
            completion(false)
        }
    }
    
}
