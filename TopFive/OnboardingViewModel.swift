//
//  OnboardingViewModel.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/11/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewModel {
    
    func createCategories() -> [CategoryView] {
        let categories = [
            CategoryView(name: "Science", sources: [.techCrunch]),
            CategoryView(name: "Politics", sources: [.businessInsider]),
            CategoryView(name: "Business", sources: [.buzzFeed]),
        ]
        return categories
    }
    
    func storeUserSelectedCategories(_ categories: [CategoryView]) {
        var selected = [String]()
        categories.forEach { selected.append($0.name) }
        UserDefaults.standard.set(selected, forKey: UserDefaultsKeys.sources)
    }
    
}
