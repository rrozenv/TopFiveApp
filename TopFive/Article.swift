//
//  Article.swift
//  NewsList
//
//  Created by Robert Rozenvasser on 3/18/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

final class Article {
    let source: Source?
    var id: String
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var numberOfReplies: Int = 0
    var numberOfHearts: Int = 0
    var isLiked = false
    var publishedDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: publishedAt) else { return nil }
        return date
    }
    
    init?(source: String, dict: [String: Any]) {
        switch source {
        case "business-insider":
            self.source = Source.businessInsider
        case "buzzfeed":
            self.source = Source.buzzFeed
        case "espn":
            self.source = Source.espn
        case "techcrunch":
            self.source = Source.techCrunch
        default:
            self.source = nil
            print("Not a valid source.")
        }
        
        guard let publishedAt = dict["publishedAt"] as? String else { return nil }
        guard let author = dict["author"] as? String else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let description = dict["description"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let urlToImage = dict["urlToImage"] as? String else { return nil }
        
        self.publishedAt = publishedAt
        self.author = author
        self.id = ("\(publishedAt) + \(author)").makeFirebaseString()
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
    }

}
