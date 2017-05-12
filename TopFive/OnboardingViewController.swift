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
    var selectedCategories = [CategoryView]()

    var categoriesStackView: CategoriesStackView! {
        didSet {
            categoriesStackView.categoryViews.forEach {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didSelectCategory(_:)))
                $0.addGestureRecognizer(gesture)
            }
        }
    }
    
    var doneButton: UIButton! {
        didSet {
            doneButton.addTarget(self, action: #selector(didFinishSelecting), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        viewModel = OnboardingViewModel()
        setupCategoriesStackView()
        setupDoneButton()
    }
    
    func setupCategoriesStackView() {
        categoriesStackView = CategoriesStackView.init(categoryViews: viewModel.createCategories(),
                                                       stackSpacing: 25,
                                                       itemWidth: 232,
                                                       axis: .horizontal)
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
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.constrainToBottom(of: view, with: 50)
    }
    
    func didFinishSelecting() {
        viewModel.storeUserSelectedCategories(self.selectedCategories)
        NotificationCenter.default.post(name: .closeOnboardingVC, object: nil)
    }
    
    func didSelectCategory(_ sender: UITapGestureRecognizer) {
        guard let categoryView = sender.view as? CategoryView else { return }
        if categoryView.isSelected {
            categoryView.backgroundColor = UIColor.blue
            categoryView.isSelected = false
            if let index = selectedCategories.index(of: categoryView) {
                selectedCategories.remove(at: index)
            }
        } else {
            categoryView.backgroundColor = UIColor.yellow
            categoryView.isSelected = true
            selectedCategories.append(categoryView)
        }
        doneButton.alpha = !selectedCategories.isEmpty ? 1.0 : 0.0
    }
    
}

