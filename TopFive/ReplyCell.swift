//
//  ReplyCell.swift
//  TopFive
//
//  Created by Robert Rozenvasser on 4/1/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    let borderView = UIView()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        return nameLabel
    }()
    
    let contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        return contentLabel
    }()
    
    let userImagePlaceholderView: UIView = {
        let placeholderView = UIView()
        placeholderView.backgroundColor = Palette.lightGrey.color
        placeholderView.layer.masksToBounds = true
        placeholderView.layer.cornerRadius = 17.5
        return placeholderView
    }()
    
    let heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.setImage(#imageLiteral(resourceName: "Bold_Heart_Icon"), for: .normal)
        return heartButton
    }()
    
    let repliesLabel: UILabel = {
        let repliesLabel = UILabel()
        repliesLabel.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        return repliesLabel
    }()
    
    let heartsLabel: UILabel = {
        let heartsLabel = UILabel()
        heartsLabel.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        return heartsLabel
    }()

    
    var post: Post! {
        didSet {
            nameLabel.text = post.userName
            contentLabel.text = post.content
            heartsLabel.text = "0 likes"
            repliesLabel.text = "0 replies"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupBorderView()
        setupPlaceholderView()
        setupNameLabel()
        setupContentLabel()
        setupHeartButton()
        setupHeartButton()
        setupHeartsLabel()
    }
    
    func setupBorderView() {
        contentView.addSubview(borderView)
        borderView.backgroundColor = Palette.lightGrey.color
        
        //Contraints
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        borderView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
    }
 
    
    func setupPlaceholderView() {
        contentView.addSubview(userImagePlaceholderView)
        userImagePlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        
        userImagePlaceholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17.0).isActive = true
        userImagePlaceholderView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 16.0).isActive = true
        userImagePlaceholderView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        userImagePlaceholderView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leadingAnchor.constraint(equalTo: userImagePlaceholderView.trailingAnchor, constant: 10.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 30.0).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: userImagePlaceholderView.centerYAnchor).isActive = true
    }
    
    func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17.0).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.0).isActive = true
        contentLabel.topAnchor.constraint(equalTo: userImagePlaceholderView.bottomAnchor, constant: 17.0).isActive = true
    }
    
    func setupHeartButton() {
        contentView.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18.0).isActive = true
        heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17.0).isActive = true
        heartButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        heartButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
    }

    
    func setupHeartsLabel() {
        contentView.addSubview(heartsLabel)
        heartsLabel.translatesAutoresizingMaskIntoConstraints = false
        heartsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17.0).isActive = true
        heartsLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor).isActive = true
    }
    
}
