
import UIKit

protocol LoadViewControllerDelegate: class {
    func loadWebView(_ article: Article)
    func loadRepliesViewController(_ article: Article)
    func reloadTableView()
}

protocol ReplyCountDelegate: class {
    func updateReplyCount()
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateReplyCount), name: NSNotification.Name("replyCount"), object: nil)
        contentView.addSubview(articleView)
        articleView.translatesAutoresizingMaskIntoConstraints = false
        articleView.constrainEdges(to: self.contentView)
    }

    var article: Article! {
        didSet {
            articleView.createArticle(article: article)
            articleView.replyButton.addTarget(self, action: #selector(didPressReplyButton), for: .touchUpInside)
            articleView.heartButton.addTarget(self, action: #selector(didPressLikeButton), for: .touchUpInside)
            currentLikeCount = article.numberOfHearts
        }
    }
    
}

extension HomeArticleCell {
    
    func didPressLikeButton() {
        if !article.isLiked {
            currentLikeCount += 1
            article.isLiked = true
            article.numberOfHearts += 1
            FirebaseManager.updateLikeCount(articleID: article.id, articleReplies: currentLikeCount)
            articleView.heartsLabel.text = "\(currentLikeCount) likes"
        } else {
            currentLikeCount -= 1
            article.isLiked = false
            article.numberOfHearts -= 1
            FirebaseManager.updateLikeCount(articleID: article.id, articleReplies: currentLikeCount)
            articleView.heartsLabel.text = "\(currentLikeCount) likes"
        }
    }
    
    func updateReplyCount() {
        articleView.repliesLabel.text = "\(article.numberOfReplies) replies"
    }
    
    func didPressButton(sender: UIButton) {
        delegate?.loadWebView(self.article)
    }
    
    func didPressReplyButton(sender: UIButton) {
        delegate?.loadRepliesViewController(self.article)
    }
    
}
