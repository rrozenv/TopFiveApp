//
//  CategoryView.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 5/12/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import Foundation
import UIKit

final class CategoryView: UIView {
    let name: String
    let nameLabel: UILabel
    let sources: [Source]
    var isSelected = false
    
    init(name: String, sources: [Source]) {
        self.name = name
        nameLabel = UILabel()
        self.nameLabel.text = name
        self.sources = sources
        super.init(frame: .zero)
        self.backgroundColor = UIColor.blue
        setupNameLabel()
        setupShadows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.center(in: self)
    }
    
    func setupShadows() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = Palette.grey.color.cgColor
        self.layer.shadowOffset = CGSize(width: -10, height: 10)  //Here you control x and y
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 50 //Here your control your blur
    }
}
