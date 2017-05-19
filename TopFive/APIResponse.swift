//
//  APIResponse.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/2/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation

enum APIResponse {
    case success(JSON)
    case badURL(String)
    case badJSONRequest(String)
    case badJSONSerialization(String)
}
