//
//  TabBarView.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/11/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

class TabBarView: UIView {
    let homeButton: UIButton
    let shareButton: UIButton
    let categoriesButton: UIButton
    let sliderView: UIView
    var sliderViewCenterXContraint: NSLayoutConstraint?
    let currentlySelected: UIButton
    
    init() {
        self.homeButton = UIButton()
        self.homeButton.tag = 1
        self.shareButton = UIButton()
        self.shareButton.tag = 2
        self.categoriesButton = UIButton()
        self.categoriesButton.tag = 3
        self.sliderView = UIView()
        self.currentlySelected = homeButton
        super.init(frame: .zero)
        setupShareButton()
        setupHomeButton()
        setupCategoriesButton()
        setupSliderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHomeButton() {
        self.addSubview(homeButton)
        homeButton.setImage(#imageLiteral(resourceName: "ic_home_not_tapped"), for: .normal)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        homeButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        homeButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -60).isActive = true
        homeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setupShareButton() {
        self.addSubview(shareButton)
        shareButton.setImage(#imageLiteral(resourceName: "ic_plus_not_tapped"), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.center(in: self)
    }
    
    func setupCategoriesButton() {
        self.addSubview(categoriesButton)
        categoriesButton.setImage(#imageLiteral(resourceName: "ic_categories_not_tapped"), for: .normal)
        categoriesButton.translatesAutoresizingMaskIntoConstraints = false
        categoriesButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        categoriesButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        categoriesButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 60).isActive = true
        categoriesButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setupSliderView() {
        sliderView.backgroundColor = Palette.blue.color
        self.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        sliderView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        sliderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sliderViewCenterXContraint = sliderView.centerXAnchor.constraint(equalTo: homeButton.centerXAnchor)
        sliderViewCenterXContraint?.isActive = true
    }
}
