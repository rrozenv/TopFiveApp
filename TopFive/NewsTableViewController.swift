
import UIKit

final class HomeViewController: UIViewController {
    
    fileprivate let tableView = UITableView()
    fileprivate let cellID = "cellID"
    fileprivate let dataShare = ArticleDataStorage.articleDataStore
    fileprivate var sources = [Source]()
    fileprivate var viewModel: NewsTableViewModel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(sources: [Source]) {
        self.init(nibName: nil, bundle: nil)
        self.sources = sources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupTableView()
        viewModel = NewsTableViewModel(sources: sources, reloadTableViewCallback: reloadTableViewCallback)
        print("News table view viewDidLoad called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("News Table View is being deinitalized")
    }
    
    func reloadTableViewCallback() {
        print("Im reloading")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.register(HomeArticleCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 256.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.constrainEdges(to: view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeArticleCell
        cell.article = viewModel.allArticles[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
}

extension HomeViewController: LoadViewControllerDelegate {
    
    func loadWebView(_ article: Article) {
        let webController = WebViewController()
        webController.article = article
        self.navigationController?.pushViewController(webController, animated: false)
    }
    
    func loadRepliesViewController(_ article: Article) {
        print("Loading replies vc")
        let repliesVC = RepliesViewController()
        repliesVC.article = article
        self.navigationController?.pushViewController(repliesVC, animated: false)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
}




