
import Foundation
import UIKit

class NewsTableViewModel {
    
    var reloadTableViewCallback: () -> Void!
    var sources = [Source]()
    var allArticles = [Article]()

    init(sources: [Source], reloadTableViewCallback: @escaping () -> Void) {
        self.sources = sources
        self.reloadTableViewCallback = reloadTableViewCallback
        createArticlesFor(sources) { 
            self.allArticles.sort(by: { $0.publishedDate! > $1.publishedDate! })
            self.reloadTableViewCallback()
        }
    }
    
    private func createArticlesFor(_ sources: [Source], completion: @escaping () -> Void) {
        self.allArticles.removeAll()
        sources.forEach { (source) in
            APIManager.getRequestFor(source) { [weak self] (APIResponse) in
                self?.checkAPIResponse(APIResponse) { [weak self] (articles) in
                    if let articles = articles {
                        self?.allArticles += articles
                        completion()
                    }
                }
            }
        }
    }
    
    private func checkAPIResponse(_ APIResponse: APIResponse, completion: ([Article]?) -> Void) {
        switch APIResponse {
        case .success(let JSON):
            createArticleObjectsWith(JSON: JSON, completion: { (articles) in
                if let articles = articles {
                    fetchReplyCounts(articles: articles)
                    fetchLikeCounts(articles: articles)
                    completion(articles)
                }
            })
        case .badJSONRequest(_):
            completion(nil)
        default:
            completion(nil)
        }
    }
    
    private func createArticleObjectsWith(JSON: JSON, completion: ([Article]?) -> Void) {
        guard let source = JSON["source"] as? String else { completion(nil); return }
        guard let articlesDict = JSON["articles"] as? [[String: Any]] else { completion(nil); return }
        var articles = [Article]()
        for article in articlesDict {
            if let article = Article(source: source, dict: article) {
                articles.append(article)
            }
        }
        !articles.isEmpty ? completion(articles) : completion(nil)
    }
    
    private func fetchReplyCounts(articles: [Article]) {
        for article in articles {
            FirebaseManager.fetchReplyCount(articleID: article.id, completion: { (replyCount) in
                article.numberOfReplies = replyCount
            })
        }
    }
    
    private func fetchLikeCounts(articles: [Article]) {
        for article in articles {
            FirebaseManager.fetchLikeCount(articleID: article.id, completion: { (likeCount) in
                article.numberOfHearts = likeCount
            })
        }
    }

}
