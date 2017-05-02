//
//  WebViewController.swift
//  NewsList
//
//  Created by Robert Rozenvasser on 3/19/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    let webViewTest = UIWebView()
    
    var article: Article! {
        didSet {
            guard let url = URL(string: self.article.url) else { return }
            let urlRequest = URLRequest(url: url)
            webViewTest.loadRequest(urlRequest)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func setupWebView() {
        view.addSubview(webViewTest)
        
        webViewTest.translatesAutoresizingMaskIntoConstraints = false
        webViewTest.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webViewTest.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webViewTest.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        webViewTest.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }


}
