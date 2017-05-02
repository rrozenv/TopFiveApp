//
//  FirebaseManager.swift
//  UserPosts
//
//  Created by Robert Rozenvasser on 3/27/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let ref = FIRDatabase.database().reference()
    static let usersRef = FIRDatabase.database().reference(withPath: "users")
    static let postsRef = FIRDatabase.database().reference(withPath: "posts")
    static let articlesRef = FIRDatabase.database().reference(withPath: "articles")

    
    class func createNewUser(name: String, email: String, password: String, completion: @escaping (Bool) -> ()) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("Error: \(error). Could not create user.")
                completion(false)
            }
            
            guard let user = user else { return }
            let reference = usersRef.child(user.uid)
            let values = ["name": name, "email": email]
            reference.updateChildValues(values)
            completion(true)
        })
    }
    
    class func loginUser(email: String, password:String, completion: @escaping (Bool) -> ()) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("Error: \(error). Could not login user.")
                completion(false)
            }
            
            if let user = user {
                print("EXISTING USER: \(user), SIGNED IN!")
                completion(true)
            }
          
        })
    }
    
    class func signOutUser() {
        do { try FIRAuth.auth()?.signOut() } catch { print("User was never signed in") }
    }

}

extension FirebaseManager {
    
    class func fetchPosts(articleID: String, completion: @escaping ([Post]) -> ()) {
        
        articlesRef.child(articleID).observe(.value, with: { (snapshot) in
            print("Snapshot: \(snapshot)")
            var posts = [Post]()
            for item in snapshot.children {
                let post = Post(snapshot: item as! FIRDataSnapshot)
                posts.append(post)
            }
            completion(posts)
        })
        
    }
    
    class func createPost(articleID: String, userId: String, userName: String, content: String, articleReplies: Int) {
        let values = ["userId": userId, "userName": userName, "content": content, "articleID": articleID]
        postsRef.childByAutoId().setValue(values)
        usersRef.child(userId).child("posts").childByAutoId().setValue(content)
        articlesRef.child(articleID).childByAutoId().updateChildValues(values)
//        articlesRef.child(articleID).child("numberOfReplies").setValue(articleReplies)
    }
}


