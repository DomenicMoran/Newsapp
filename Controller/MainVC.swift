//
//  MainVC.swift
//  Newsapp
//
//  Created by Domenic Moran on 09.08.22.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate {

    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    
    var dataSource: UITableViewDiffableDataSource<Section, Article>!
    
    private var articels: [Article] = []
    
    private var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureRefreshControl()
        configureTableView()
        configurDataSource()
        updateNewsItems()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateNewsItems), for: .valueChanged)
    }
    
    @objc
    func updateNewsItems() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
        showLoadingSpinner()
        NetworkManager.shared.getNewsItems { (result) in
            switch result {
            case .success(let newsResponse):
                self.articels = newsResponse.articles
                self.updateData(articel: newsResponse.articles)
            case .failure(let error):
                self.presentWarningAlert(title: "Fehler", message: error.rawValue)
            }
            self.dismissLoadingSpinner()
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Nachrichten"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToEdges(of: view)
        tableView.register(NewsTVC.self, forCellReuseIdentifier: NewsTVC.reuseID)
    }
    
    func configurDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Article>(tableView: tableView, cellProvider: { (tableView, indexPath, Articel) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTVC.reuseID, for: indexPath) as? NewsTVC
            
            cell?.setCell(articel: Articel)
            
            return cell!
        })

    }
    
    func updateData(articel: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.main])
        snapshot.appendItems(articel)
        self.dataSource.apply(snapshot)
    }
    
    func showLoadingSpinner() {
        containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToEdges(of: view)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.6
        }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingSpinner () {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedArticel = dataSource.itemIdentifier(for: indexPath){
            let detailVC = DetailVC(article: selectedArticel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

