
import UIKit

protocol LoadViewControllerDelegate: class {
    func loadWebView(_ article: Article)
    func loadRepliesViewController(_ article: Article)
    func reloadTableView()
}

class HomeArticleCell: UITableViewCell {
    
    var articleView = ArticleView()
    weak var delegate: LoadViewControllerDelegate?
    var currentLikeCount: Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupArticleView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateReplyCount), name: NSNotification.Name("replyCount"), object: nil)
    }

    var article: Article! {
        didSet {
            articleView.createArticle(article: article)
            articleView.webViewButton.addTarget(self, action: #selector(didPressWebviewButton), for: .touchUpInside)
            articleView.replyButton.addTarget(self, action: #selector(didPressReplyButton), for: .touchUpInside)
            articleView.heartButton.addTarget(self, action: #selector(didPressLikeButton), for: .touchUpInside)
            //currentLikeCount = article.numberOfHearts
        }
    }
    
    func setupArticleView() {
        articleView = ArticleView()
        contentView.addSubview(articleView)
        articleView.translatesAutoresizingMaskIntoConstraints = false
        articleView.constrainEdges(to: self.contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

//MARK: Actions 

extension HomeArticleCell {
    
    func didPressLikeButton() {
        //TODO: Add Heart Animation
        if !article.isLiked {
            article.isLiked = true
            article.numberOfHearts += 1
            FirebaseManager.updateLikeCount(articleID: article.id, articleReplies: article.numberOfHearts)
            articleView.heartsLabel.text = "\(article.numberOfHearts) likes"
        } else {
            article.isLiked = false
            article.numberOfHearts -= 1
            FirebaseManager.updateLikeCount(articleID: article.id, articleReplies: article.numberOfHearts)
            articleView.heartsLabel.text = "\(article.numberOfHearts) likes"
        }
    }
    
    func didPressWebviewButton(sender: UIButton) {
        delegate?.loadWebView(self.article)
    }
    
    func didPressReplyButton(sender: UIButton) {
        delegate?.loadRepliesViewController(self.article)
    }
}

//MARK: Notification Center Action

extension HomeArticleCell {
    
    func updateReplyCount() {
        articleView.repliesLabel.text = "\(article.numberOfReplies) replies"
    }
    
}
