//
//  Post.swift
//  UserPosts
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import Firebase

class Post {
    let userName: String
    let content: String
    
    init(userName: String, content: String) {
        self.userName = userName
        self.content = content
    }
    
    init?(snapshot: FIRDataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        guard let userName = dict["userName"] else { return nil }
        guard let content = dict["content"] else { return nil }
        self.userName = userName
        self.content = content
    }
    
}
