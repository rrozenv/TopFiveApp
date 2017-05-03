//
//  RepliesViewController.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/30/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RepliesViewController: UIViewController {
    
    let borderView = UIView()
    let articleImage = UIImageView()
    let blackFilter = UIView()
    let webViewButton = UIButton()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    var articleID: String?
    
    var posts = [Post]()
    var textFieldBottomConstraint: NSLayoutConstraint!
    
    var curretUserUID: String?
    var userName: String?
    
    let postTextField: TextField = {
        let tf = TextField()
        tf.placeholder = "Write your post..."
        tf.backgroundColor = Palette.lightGrey.color
        tf.font = UIFont(name: "Avenir-Medium", size: 14.0)
        tf.textColor = Palette.grey.color
        return tf
    }()
    
    let tableView = UITableView()
    
    var article: Article! {
        didSet {
            self.articleID = article.id
            titleLabel.text = article.title
        }
    }
    
    weak var delegate: LoadViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBorderView()
        setupImageView()
        setupBlackFilterView()
        setupWebViewButton()
        setupTitleLabel()
        setupTableView()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let articleID = article.id {
            
            FirebaseManager.fetchPosts(articleID: articleID, completion: { (posts) in
                self.posts = posts
                self.tableView.reloadData()
            })
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

extension RepliesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension RepliesViewController: UITextFieldDelegate {
    
    func setupTextField() {
        view.insertSubview(postTextField, aboveSubview: tableView)
        postTextField.delegate = self
        postTextField.translatesAutoresizingMaskIntoConstraints = false
        postTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        textFieldBottomConstraint = postTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        textFieldBottomConstraint.isActive = true
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        checkIfUserIsLoggedIn { (isLoggedIn) in
            
            if isLoggedIn {
                self.adjustingHeight(true, notification: notification)
                self.userName = UserDefaults.standard.string(forKey: "userName")!
                self.curretUserUID = FIRAuth.auth()?.currentUser?.uid
                
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.hideKeybordWithNoText))
                self.tableView.addGestureRecognizer(tap)
            }
        }
    }
    
    func hideKeybordWithNoText() {
        view.endEditing(true)
        self.postTextField.text = nil
    }
    
    func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let changeInHeight = (keyboardFrame.height) * (show ? -1 : 1)
        if show {
            self.textFieldBottomConstraint.constant += changeInHeight
        } else {
            print(changeInHeight)
            self.textFieldBottomConstraint.constant = 0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let userId = curretUserUID, let postText = postTextField.text, let articleID = article.id {
            self.article.numberOfReplies += 1
            FirebaseManager.createPost(articleID: articleID, userId: userId, userName: userName!, content: postText, articleReplies: article.numberOfReplies)
            textField.resignFirstResponder()
            postTextField.text = nil
            return true
        }
        return false
    }

}

extension RepliesViewController {
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(ReplyCell.self, forCellReuseIdentifier: "replyCell")
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 256.0
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: articleImage.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    func setupBorderView() {
        view.addSubview(borderView)
        borderView.backgroundColor = Palette.lightGrey.color
        
        //Contraints
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        borderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
    }
    
    func setupImageView() {
        view.addSubview(articleImage)
        articleImage.contentMode = UIViewContentMode.scaleAspectFill
        articleImage.clipsToBounds = true
        
        //Constraints
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        articleImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        articleImage.topAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        articleImage.heightAnchor.constraint(equalToConstant: 168.0).isActive = true
    }
    
    func setupBlackFilterView() {
        blackFilter.backgroundColor = UIColor.black
        blackFilter.alpha = 0.6
        view.insertSubview(blackFilter, aboveSubview: articleImage)
        
        blackFilter.translatesAutoresizingMaskIntoConstraints = false
        blackFilter.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor).isActive = true
        blackFilter.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor).isActive = true
        blackFilter.topAnchor.constraint(equalTo: articleImage.topAnchor).isActive = true
        blackFilter.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor).isActive = true
    }
    
    func setupWebViewButton() {
        view.insertSubview(webViewButton, aboveSubview: blackFilter)
        webViewButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        webViewButton.tag = 1
        
        webViewButton.translatesAutoresizingMaskIntoConstraints = false
        webViewButton.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor).isActive = true
        webViewButton.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor).isActive = true
        webViewButton.topAnchor.constraint(equalTo: blackFilter.topAnchor).isActive = true
        webViewButton.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor).isActive = true
    }
    
    func setupTitleLabel() {
        view.insertSubview(titleLabel, aboveSubview: blackFilter)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
        titleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor, constant: -17.0).isActive = true
    }
    
    func setupCategoryLabel() {
        view.insertSubview(categoryLabel, aboveSubview: blackFilter)
        categoryLabel.textColor = UIColor.lightGray
        categoryLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        categoryLabel.numberOfLines = 0
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -7.0).isActive = true
    }
    
    func didPressButton(sender: UIButton) {
        delegate?.loadWebView(self.article)
    }

}

extension RepliesViewController {
    
    func checkIfUserIsLoggedIn(completion: @escaping (Bool) -> ()) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogOut))
            completion(false)
        } else {
            completion(true)
        }
    }
    
    func handleLogOut() {
        FirebaseManager.signOutUser()
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }

}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}


