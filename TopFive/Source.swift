//
//  Source.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/15/17.
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
