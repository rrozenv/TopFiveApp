//
//  ViewController.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    fileprivate let tableView = UITableView()
    fileprivate let cellID = "cellID"
    fileprivate let dataShare = ArticleDataStorage.articleDataStore
    fileprivate var sources = [Source]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(sources: [Source]) {
        self.init(nibName: nil, bundle: nil)
        self.sources = sources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
        updateTableViewWithArticlesFrom(sources: sources)
    }
    
    func updateTableViewWithArticlesFrom(sources: [Source]) {
        dataShare.createArticlesFor(sources) { (isSuccess) in
            if isSuccess {
                self.dataShare.allArticles.sort(by: { $0.publishedDate! > $1.publishedDate! })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.register(HomeArticleCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 256.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataShare.allArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeArticleCell
        cell.article = dataShare.allArticles[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
}

extension HomeViewController: LoadViewControllerDelegate {
    
    func loadWebView(_ article: Article) {
        let webController = WebViewController()
        webController.article = article
        self.navigationController?.pushViewController(webController, animated: false)
    }
    
    func loadRepliesViewController(_ article: Article) {
        print("Loading replies vc")
        let repliesVC = RepliesViewController()
        repliesVC.article = article
        self.navigationController?.pushViewController(repliesVC, animated: false)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
}

