//
//  FavoriteVC.swift
//  Newsapp
//
//  Created by Domenic Moran on 12.08.22.
//

import UIKit

class FavoriteNewsItemDataSource: UITableViewDiffableDataSource<MainVC.Section, Article> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let article = itemIdentifier(for: indexPath) {
                var snapshot = self.snapshot()
                snapshot.deleteItems([article])
                apply(snapshot)
                
                PersistenceManager.shared.removeFavArticle(article: article) {
                    NotificationCenter.default.post(name: .favoriteDidChange, object: nil)
                }
            }
        }
    }
    
}

class FavoriteVC: MainVC {
    
    private let emptyStateView = EmptyStateView(imageSystemName: "star", text: "Keine Favoriten verfügbar.")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        tableView.refreshControl = nil
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewsItems), name: .favoriteDidChange, object: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    override func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favoriten"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override func updateNewsItems() {
        self.articels = PersistenceManager.shared.getAllFavArticles()
        updateData(articel: articels)
        
        if articels.isEmpty {
            tableView.backgroundView = emptyStateView
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = nil
            tableView.isScrollEnabled = false
        } else {
            tableView.backgroundView = nil
            tableView.isScrollEnabled = true
        }
    }
    override func configurDataSource() {
        dataSource = FavoriteNewsItemDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, article) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTVC.reuseID, for: indexPath) as? NewsTVC
            
            cell?.setCell(articel: article)
            return cell
        })
    }
}
