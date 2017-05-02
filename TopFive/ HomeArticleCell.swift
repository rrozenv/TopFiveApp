//
//  HomeArticleCell.swift
//  NewsList
//
//  Created by Robert Rozenvasser on 3/19/17.
//  Copyright © 2017 Robert Rozenvasser. All rights reserved.
//

import UIKit

protocol LoadViewControllerDelegate: class {
    func loadWebView(_ article: Article)
    func loadRepliesViewController(_ article: Article)
}

class HomeArticleCell: UITableViewCell {
    
    let borderView = UIView()
    let articleImage = UIImageView()
    let blackFilter = UIView()
    let webViewButton = UIButton()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let replyButton: UIButton = {
        let replyButton = UIButton()
        replyButton.setImage(#imageLiteral(resourceName: "Bold_Reply_Icon"), for: .normal)
        return replyButton
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
    
    weak var delegate: LoadViewControllerDelegate?
    
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
        setupImageView()
        setupBlackFilterView()
        setupWebViewButton()
        setupTitleLabel()
        setupCategoryLabel()
        setupReplyButton()
        setupHeartButton()
        setupDescriptionLabel()
        setupHeartsLabel()
        setupRepliesLabel()
    }
    
    var article: Article! {
        didSet {
            articleImage.setImage(urlString: article.urlToImage)
            titleLabel.text = article.title.capitalized
            descriptionLabel.text = article.description
            heartsLabel.text = "0 likes"
            repliesLabel.text = "\(article.numberOfReplies) replies"
        }
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
    
    func setupImageView() {
        contentView.addSubview(articleImage)
        articleImage.contentMode = UIViewContentMode.scaleAspectFill
        articleImage.clipsToBounds = true
        
        //Constraints
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        articleImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        articleImage.topAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        articleImage.heightAnchor.constraint(equalToConstant: 168.0).isActive = true
    }

    func setupBlackFilterView() {
        blackFilter.backgroundColor = UIColor.black
        blackFilter.alpha = 0.6
        contentView.insertSubview(blackFilter, aboveSubview: articleImage)
        
        blackFilter.translatesAutoresizingMaskIntoConstraints = false
        blackFilter.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor).isActive = true
        blackFilter.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor).isActive = true
        blackFilter.topAnchor.constraint(equalTo: articleImage.topAnchor).isActive = true
        blackFilter.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor).isActive = true
    }
    
    func setupWebViewButton() {
        contentView.insertSubview(webViewButton, aboveSubview: blackFilter)
        webViewButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        webViewButton.tag = 1
        
        webViewButton.translatesAutoresizingMaskIntoConstraints = false
        webViewButton.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor).isActive = true
        webViewButton.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor).isActive = true
        webViewButton.topAnchor.constraint(equalTo: blackFilter.topAnchor).isActive = true
        webViewButton.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor).isActive = true
    }
    
    func setupTitleLabel() {
        contentView.insertSubview(titleLabel, aboveSubview: blackFilter)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
        titleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor, constant: -17.0).isActive = true
    }
    
    func setupCategoryLabel() {
        contentView.insertSubview(categoryLabel, aboveSubview: blackFilter)
        categoryLabel.textColor = UIColor.lightGray
        categoryLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        categoryLabel.numberOfLines = 0
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -7.0).isActive = true
    }
    
    func setupDescriptionLabel() {
        contentView.insertSubview(descriptionLabel, aboveSubview: blackFilter)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17.0).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17.0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: blackFilter.bottomAnchor, constant: 17.0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: heartButton.topAnchor, constant: -17.0).isActive = true
    }
    
    func setupReplyButton() {
        contentView.addSubview(replyButton)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.addTarget(self, action: #selector(didPressReplyButton), for: .touchUpInside)
        replyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18.0).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17.0).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    func setupHeartButton() {
        contentView.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        heartButton.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -29.0).isActive = true
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
    
    func setupRepliesLabel() {
        contentView.addSubview(repliesLabel)
        repliesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        repliesLabel.leadingAnchor.constraint(equalTo: heartsLabel.trailingAnchor, constant: 10.0).isActive = true
        repliesLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor).isActive = true
    }
    
    func didPressButton(sender: UIButton) {
        delegate?.loadWebView(self.article)
    }
    
    func didPressReplyButton(sender: UIButton) {
        delegate?.loadRepliesViewController(self.article)
    }
    
}
