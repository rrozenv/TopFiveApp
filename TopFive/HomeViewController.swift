//
//  ViewController.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 3/29/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    let cellID = "cellID"
    let dataShare = ArticleDataStorage.articleDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
        
        dataShare.createAllArticles { (didCreateArticles) in
            if didCreateArticles {
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(HomeArticleCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 256.0
        tableView.rowHeight = UITableViewAutomaticDimension
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
        let repliesVC = RepliesViewController()
        repliesVC.article = article
        self.navigationController?.pushViewController(repliesVC, animated: false)
    }
    
}


