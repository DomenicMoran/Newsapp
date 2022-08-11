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
    
    func addFav (article: Article) {
        var favorites = getAllFavArticles()
        
        favorites.append(article)
        save(articles: favorites)
    }
    func getAllFavArticles () -> [Article] {
        guard let favData = UserDefaults.standard.object(forKey: articlesKey) as? Data, let articles = try? JSONDecoder().decode([Article].self, from: favData) else { return [] }
        return articles
    }
    
    func save(articles: [Article]) {
        guard let dataToSave = try? JSONEncoder().encode(articles) else {
            return
        }
        UserDefaults.standard.set(dataToSave, forKey: articlesKey)
    }
}
