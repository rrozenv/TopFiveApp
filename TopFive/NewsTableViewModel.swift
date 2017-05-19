
import Foundation
import UIKit

class NewsTableViewModel {
    
    var reloadTableViewCallback: () -> Void!
    var sources = [Source]()
    var allArticles = [Article]()
    let myGroup = DispatchGroup()
    var sourceCounter = 0


    init(sources: [Source], reloadTableViewCallback: @escaping () -> Void) {
        self.sources = sources
        self.reloadTableViewCallback = reloadTableViewCallback
        createArticlesFor(sources) {
            if self.sourceCounter == sources.count {
                self.fetchReplyCounts(articles: self.allArticles, completion: {
                    self.fetchLikeCounts(articles: self.allArticles, completion: { 
                         self.reloadTableViewCallback()
                    })
                })
                self.allArticles.sort(by: { $0.publishedDate! > $1.publishedDate! })
            }
        }
    }
    
    private func createArticlesFor(_ sources: [Source], completion: @escaping () -> Void) {
        self.allArticles.removeAll()
        sources.forEach { (source) in
            APIManager.getRequestFor(source) { [weak self] (APIResponse) in
                switch APIResponse {
                case .success(let JSON):
                    print("Creating articles for \(String(describing: source))")
                    self?.createArticleObjectsWith(JSON: JSON, completion: { (articles) in
                        if let articles = articles {
                            print("Adding \(articles.count) articles created for \(source) to array")
                            self?.sourceCounter += 1
                            self?.allArticles += articles
                            completion()
                        }
                    })
                case .badJSONRequest(_):
                    completion()
                default:
                    completion()
                }
            }
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
    
    private func fetchReplyCounts(articles: [Article], completion: @escaping () -> Void) {
        print("Fetching replies for ALL \(articles.count) articles")
        let articleCount = articles.count
        var counter = 0
        for article in articles {
            FirebaseManager.fetchReplyCount(articleID: article.id, completion: { (count) in
                article.numberOfReplies = count
                counter += 1
                print("Got replies. \(counter)")
                if counter == articleCount {
                    completion()
                }
            })
        }
    }
    
    private func fetchLikeCounts(articles: [Article], completion: @escaping () -> Void) {
        print("Fetching replies for ALL \(articles.count) articles")
        let articleCount = articles.count
        var counter = 0
        for article in articles {
            FirebaseManager.fetchLikeCount(articleID: article.id, completion: { (count) in
                article.numberOfHearts = count
                counter += 1
                if counter == articleCount {
                    completion()
                }
            })
        }
    }

    

    

    

    


}

enum Counts: String {
    case numberOfReplies
    case numberOfLikes
}
