//
//  PersistenceManager.swift
//  Newsapp
//
//  Created by Domenic Moran on 11.08.22.
//

import Foundation


class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private let articlesKey = "Articles_UserDefaults"
    private let defaults = UserDefaults.standard
    
    func addFav (article: Article, onSuccess: () -> ()) {
        var favorites = getAllFavArticles()
        
        favorites.append(article)
        save(articles: favorites, onSuccess: onSuccess)
    }
    func getAllFavArticles () -> [Article] {
        guard let favData = defaults.object(forKey: articlesKey) as? Data, let articles = try? JSONDecoder().decode([Article].self, from: favData) else { return [] }
        return articles
    }
    func removeFavArticle (article: Article, onSuccess: () -> ()) {
        var favorites = getAllFavArticles()
        guard let indexOfArticle = favorites.firstIndex(of: article) else { return }
        favorites.remove(at: indexOfArticle)
        
        save(articles: favorites, onSuccess: onSuccess)
    }
    
    func isArticleAlreadyFav(article: Article) -> Bool {
        let articles = getAllFavArticles()
        return articles.contains(article)
        
    }
    
    
    private func save(articles: [Article], onSuccess: () -> ()) {
        guard let dataToSave = try? JSONEncoder().encode(articles) else {
            return
        }
        defaults.set(dataToSave, forKey: articlesKey)
        onSuccess()
    }
}
