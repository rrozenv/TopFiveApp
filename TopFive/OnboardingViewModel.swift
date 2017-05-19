//
//  OnboardingViewModel.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/11/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

final class OnboardingViewModel {
    
    var selectedCategories = [CategoryView]()
    
    func didSelectCategory(view: CategoryView) -> UIColor {
        if view.isSelected {
            view.isSelected = false
            if let index = selectedCategories.index(of: view) {
                selectedCategories.remove(at: index)
            }
            return UIColor.blue
        } else {
            view.isSelected = true
            selectedCategories.append(view)
            return UIColor.yellow
        }
    }
        
    func createCategories() -> [CategoryView] {
        let categories = [
            CategoryView(name: "Science", sources: [.techCrunch]),
            CategoryView(name: "Politics", sources: [.businessInsider]),
            CategoryView(name: "Business", sources: [.buzzFeed]),
        ]
        return categories
    }
    
    func storeUserSelectedCategories() {
        var selected = [String]()
        selectedCategories.forEach { selected.append($0.name) }
        UserDefaults.standard.set(selected, forKey: UserDefaultsKeys.sources)
    }
    
}
