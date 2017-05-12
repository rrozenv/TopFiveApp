//
//  MasterTabBarController.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/11/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class MasterTabBarController: UIViewController {
    
    fileprivate var sources = [Source]()
    
    private lazy var homeViewController: HomeViewController = {
        var viewController = HomeViewController(sources: self.sources)
        return viewController
    }()
    
    private lazy var shareViewController: ShareViewController = {
        var viewController = ShareViewController()
        return viewController
    }()
    
    private lazy var categoriesViewController: CategoriesViewController = {
        var viewController = CategoriesViewController()
        return viewController
    }()
    
    var tabBarView: TabBarView! {
        didSet {
            tabBarView.homeButton.addTarget(self, action: #selector(didPressTabButton(_:)), for: .touchUpInside)
            tabBarView.shareButton.addTarget(self, action: #selector(didPressTabButton(_:)), for: .touchUpInside)
            tabBarView.categoriesButton.addTarget(self, action: #selector(didPressTabButton(_:)), for: .touchUpInside)
        }
    }
    
    var currentlySelectedTag: Int = 1
    var slidingView: UIView!
    var slidingViewCenterXConstraint: NSLayoutXAxisAnchor!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        fetchUserSources()
        tabBarView = TabBarView()
        setupTabBarView()
        didPressTabButton(tabBarView.homeButton)
    }
    
    func fetchUserSources() {
        if let userSelectedSources = UserDefaults.standard.array(forKey: UserDefaultsKeys.sources) as? [String] {
            userSelectedSources.forEach({ (stringSource) in
                switch stringSource {
                case "Science":
                    self.sources.append(Source.techCrunch)
                case "Politics":
                    self.sources.append(Source.businessInsider)
                default:
                    print("not a valid source")
                }
            })
        }
        print("I got \(self.sources.count) sources")
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.bottomAnchor.constraint(equalTo: tabBarView.topAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    func setupTabBarView() {
        view.addSubview(tabBarView)
        tabBarView.backgroundColor = UIColor.white
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.constrainToBottom(of: view, with: 65)
    }
    
    func didPressTabButton(_ sender: UIButton) {
        let previousTag = currentlySelectedTag
        switch previousTag {
        case 1:
            remove(asChildViewController: homeViewController)
            tabBarView.homeButton.setImage(#imageLiteral(resourceName: "ic_home_not_tapped"), for: .normal)
        case 2:
            remove(asChildViewController: shareViewController)
            tabBarView.shareButton.setImage(#imageLiteral(resourceName: "ic_plus_not_tapped"), for: .normal)
        case 3:
            remove(asChildViewController: categoriesViewController)
            tabBarView.categoriesButton.setImage(#imageLiteral(resourceName: "ic_categories_not_tapped"), for: .normal)
        default: print("Not valid tag")
        }
        currentlySelectedTag = sender.tag
        switch currentlySelectedTag {
        case 1:
            add(asChildViewController: homeViewController)
            sender.setImage(#imageLiteral(resourceName: "ic_home_tapped"), for: .normal)
        case 2:
            add(asChildViewController: shareViewController)
            sender.setImage(#imageLiteral(resourceName: "ic_plus_tapped"), for: .normal)
        case 3:
            add(asChildViewController: categoriesViewController)
            sender.setImage(#imageLiteral(resourceName: "ic_categoriest_tapped"), for: .normal)
        default: print("Not a valid tag")
        }
        
    }

}
