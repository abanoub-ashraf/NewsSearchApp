import UIKit
import SafariServices

class NewsListController: UIViewController {
    
    // MARK: - Variables -
    
    private var viewModels = [NewsCellViewModel]()
    private var articles = [Article]()
    
    // MARK: - UI -
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        return table
    }()

    // the search controller that goes inside the nav bar
    private let searchVC = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTopStories()
        
        createSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Helper Functions -
    
    private func fetchTopStories() {
        NetworkManager.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                
                // to help us tap on the link of each article to display it in safari controller
                self?.articles = articles
                
                self?.viewModels = articles.compactMap({
                    return NewsCellViewModel(
                        title: $0.title,
                        subTitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? Constants.stringImage)
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchForNews(with text: String) {
        NetworkManager.shared.search(with: text) { [weak self] result in
            switch result {
                case .success(let articles):
                    self?.articles = articles
                    
                    self?.viewModels = articles.compactMap({
                        return NewsCellViewModel(
                            title: $0.title,
                            subTitle: $0.description ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? Constants.stringImage)
                        )
                    })
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = .label
        searchVC.searchBar.delegate = self
    }

}

// MARK: - UITableViewDataSource -

extension NewsListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsCell.identifier,
                for: indexPath
        ) as? NewsCell else {
            fatalError()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate -

extension NewsListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

// MARK: - UISearchBarDelegate -

extension NewsListController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        self.searchForNews(with: text)
        searchBar.text = ""
        self.searchVC.dismiss(animated: true, completion: nil)
    }
    
}
