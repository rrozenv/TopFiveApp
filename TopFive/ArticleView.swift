
import Foundation
import UIKit

final class ArticleView: UIView {
    
    //Article properties
    var titleLabel = UILabel()
    var categoryLabel = UILabel()
    var descriptionLabel = UILabel()
    let repliesLabel = UILabel()
    let heartsLabel = UILabel()

    
    //Generic properties
    var borderView = UIView()
    var articleImageView = UIImageView()
    var blackFilter = UIView()
    var webViewButton = UIButton()
    var replyButton = UIButton()
    var heartButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createArticle(article: Article) {
        articleImageView.setImage(urlString: article.urlToImage)
        titleLabel.text = article.title
        categoryLabel.text = article.source?.rawValue
        descriptionLabel.text = article.description
        heartsLabel.text = "\(article.numberOfHearts) likes"
        repliesLabel.text = "\(article.numberOfReplies) replies"
    }
    
    func setupViews() {
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
    
    func setupBorderView() {
        self.addSubview(borderView)
        borderView.backgroundColor = Palette.lightGrey.color
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 6.0).isActive = true
    }
    
    func setupImageView() {
        self.addSubview(articleImageView)
        articleImageView.contentMode = UIViewContentMode.scaleAspectFill
        articleImageView.clipsToBounds = true
        
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        articleImageView.topAnchor.constraint(equalTo: borderView.bottomAnchor).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 168.0).isActive = true
    }
    
    func setupBlackFilterView() {
        blackFilter.backgroundColor = UIColor.black
        blackFilter.alpha = 0.6
        self.insertSubview(blackFilter, aboveSubview: articleImageView)
        
        blackFilter.translatesAutoresizingMaskIntoConstraints = false
        blackFilter.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        blackFilter.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        blackFilter.topAnchor.constraint(equalTo: articleImageView.topAnchor).isActive = true
        blackFilter.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor).isActive = true
    }
    
    func setupWebViewButton() {
        self.insertSubview(webViewButton, aboveSubview: blackFilter)
        
        webViewButton.translatesAutoresizingMaskIntoConstraints = false
        webViewButton.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor).isActive = true
        webViewButton.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor).isActive = true
        webViewButton.topAnchor.constraint(equalTo: blackFilter.topAnchor).isActive = true
        webViewButton.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor).isActive = true
    }
    
    func setupTitleLabel() {
        self.insertSubview(titleLabel, aboveSubview: blackFilter)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Avenir-Black", size: 16.0)
        titleLabel.numberOfLines = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: blackFilter.bottomAnchor, constant: -17.0).isActive = true
    }
    
    func setupCategoryLabel() {
        self.insertSubview(categoryLabel, aboveSubview: blackFilter)
        categoryLabel.textColor = UIColor.lightGray
        categoryLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        categoryLabel.numberOfLines = 0
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: blackFilter.leadingAnchor, constant: 17.0).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: blackFilter.trailingAnchor, constant: -17.0).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -7.0).isActive = true
    }
    
    func setupHeartButton() {
        self.addSubview(heartButton)
        heartButton.setImage(#imageLiteral(resourceName: "Bold_Heart_Icon"), for: .normal)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        heartButton.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -29.0).isActive = true
        heartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.0).isActive = true
        heartButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        heartButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
    }
    
    func setupDescriptionLabel() {
        self.insertSubview(descriptionLabel, aboveSubview: blackFilter)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont(name: "Avenir-Medium", size: 14.0)
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17.0).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17.0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: blackFilter.bottomAnchor, constant: 17.0).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: heartButton.topAnchor, constant: -17.0).isActive = true
    }
    
    func setupReplyButton() {
        self.addSubview(replyButton)
        replyButton.setImage(#imageLiteral(resourceName: "Bold_Reply_Icon"), for: .normal)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18.0).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17.0).isActive = true
        replyButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        replyButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    func setupHeartsLabel() {
        heartsLabel.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        self.addSubview(heartsLabel)
        heartsLabel.translatesAutoresizingMaskIntoConstraints = false
        heartsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17.0).isActive = true
        heartsLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor).isActive = true
    }
    
    func setupRepliesLabel() {
        repliesLabel.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        self.addSubview(repliesLabel)
        repliesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        repliesLabel.leadingAnchor.constraint(equalTo: heartsLabel.trailingAnchor, constant: 10.0).isActive = true
        repliesLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor).isActive = true
    }

}
