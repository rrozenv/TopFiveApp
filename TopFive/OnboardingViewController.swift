//
//  OnboardingViewController.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/10/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel!
    var categoriesStackView: CategoriesStackView!
    var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        viewModel = OnboardingViewModel()
        setupCategoriesStackView()
        setupDoneButton()
    }
    
}

//MARK: Actions 

extension OnboardingViewController {
    
    func didFinishSelecting() {
        viewModel.storeUserSelectedCategories()
        NotificationCenter.default.post(name: .closeOnboardingVC, object: nil)
    }
    
    func didSelectCategory(_ sender: UITapGestureRecognizer) {
        guard let categoryView = sender.view as? CategoryView else { return }
        categoryView.backgroundColor = viewModel.didSelectCategory(view: categoryView)
        doneButton.alpha = !viewModel.selectedCategories.isEmpty ? 1.0 : 0.0
    }
    
}

//MARK: View Setup 

extension OnboardingViewController {
    
    func setupCategoriesStackView() {
        categoriesStackView = CategoriesStackView.init(categoryViews: viewModel.createCategories(),
                                                       stackSpacing: 25,
                                                       itemWidth: 232,
                                                       axis: .horizontal)
        categoriesStackView.categoryViews.forEach {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectCategory(_:)))
            $0.addGestureRecognizer(gesture)
        }
        view.addSubview(categoriesStackView)
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        categoriesStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoriesStackView.heightAnchor.constraint(equalToConstant: 189).isActive = true
        categoriesStackView.center(in: view)
    }
    
    func setupDoneButton() {
        doneButton = UIButton()
        doneButton.backgroundColor = Palette.aqua.color
        doneButton.alpha = 0
        doneButton.addTarget(self, action: #selector(didFinishSelecting), for: .touchUpInside)
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.constrainToBottom(of: view, with: 50)
    }
    
}

