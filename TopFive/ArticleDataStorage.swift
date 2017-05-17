//
//  ArticleDataStorage.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation


final class ArticleDataStorage {
    
    static let articleDataStore = ArticleDataStorage()
    var allArticles = [Article]()
    private init () { }
    
    func createArticlesFor(_ source: [Source], completion: @escaping (Bool) -> Void) {
        self.allArticles.removeAll()
        source.forEach { (source) in
            APIManager.getRequestFor(source) { [weak self] (APIResponse) in
                self?.checkAPIResponse(APIResponse) { (isSuccess) in
                    isSuccess ? completion(true) : completion(false)
                }
            }
        }
    }
    
    func fetchReplyCounts(articles: [Article]) {
        for article in articles {
            FirebaseManager.fetchReplyCount(articleID: article.id, completion: { (replyCount) in
                article.numberOfReplies = replyCount
            })
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
