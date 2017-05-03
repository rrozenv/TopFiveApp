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
    let id: String?
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String?
    var numberOfReplies: Int = 0
    var publishedDate: Date? {
        guard let stringDate = publishedAt else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: stringDate) else { return nil }
        return date
    }
    
    init(dict: [String: Any]) {
        let publishedAt = dict["publishedAt"] as? String ?? nil
        let author = dict["author"] as? String ?? nil
        if let publishTime = publishedAt, let author = author {
             self.id = "\(publishTime) + \(author)"
        } else { self.id = nil }
        self.author = author
        self.title = dict["title"] as? String ?? "No Title"
        self.description = dict["description"] as? String ?? "No Description"
        self.url = dict["url"] as? String ?? "No url"
        self.urlToImage = dict["urlToImage"] as? String ?? "No url image"
        self.publishedAt = publishedAt
    }

}
