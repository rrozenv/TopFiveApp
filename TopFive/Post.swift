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
    
    init(snapshot: FIRDataSnapshot) {
        let dict = snapshot.value as? [String: String]
        print("\(snapshot.value)")
        self.userName = dict?["userName"] ?? ""
        self.content = dict?["content"] ?? ""
    }
}
