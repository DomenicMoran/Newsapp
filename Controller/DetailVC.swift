//
//  DetailVC.swift
//  Newsapp
//
//  Created by Domenic Moran on 10.08.22.
//

import UIKit
import SafariServices

class DetailVC: UIViewController {
    
    private let titleLabel = NewsLabel(fontStyle: .headline, numberOfLines: 0)
    
    private let imageView = NewsImageView(frame: .zero)
    
    private let infoLabel = NewsLabel(fontStyle: .footnote, numberOfLines: 0, textAlignment: .center)
    
    private let contentLabel = NewsLabel(fontStyle: .body, numberOfLines: 0)
    
    private let readArticleButton = NewsButton(backgroundColor: .systemBlue, title: "Zum ganzen Artikel")
    
    private let stackView = UIStackView()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private var articles: [Article]?
    
    private var article: Article! {
        didSet {
            guard let articles = articles, let currentIndex = articles.firstIndex(of: article) else {
                upButton.isEnabled = false
                downButton.isEnabled = false
                return
            }
            if currentIndex == 0 {
                upButton.isEnabled = false
            } else {
                upButton.isEnabled = true
            }
            if currentIndex == articles.count - 1 {
                downButton.isEnabled = false
            } else {
                downButton.isEnabled = true
            }
        }
    }
    
    let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .semibold)
    
    lazy var upButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up", withConfiguration: config), style: .plain, target: self, action: #selector(handleUpDidTapped))

    lazy var downButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down", withConfiguration: config), style: .plain, target: self, action: #selector(handleDownDidTapped))
    
    lazy var favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star", withConfiguration: config), style: .plain, target: self, action: #selector(handleFavButtonDidTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        configureUI()
        configureReadArticleButton()
        setElements(article: article)
        
        let appearance = UINavigationBarAppearance()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItems = [downButton, upButton, favoriteButton]
    }
    init(article: Article, articles: [Article]){
        super.init(nibName: nil, bundle: nil)
        
        ({
            self.articles = articles
            self.article = article
        })()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleFavButtonDidTapped() {
        if PersistenceManager.shared.isArticleAlreadyFav(article: article) {
            
            PersistenceManager.shared.removeFavArticle(article: article) {
                favoriteButton.image = UIImage(systemName: "star", withConfiguration: config)
                NotificationCenter.default.post(name: .favoriteDidChange, object: nil)
            }
        } else {
            
            PersistenceManager.shared.addFav(article: article) {
                favoriteButton.image = UIImage(systemName: "star.fill", withConfiguration: config)
                NotificationCenter.default.post(name: .favoriteDidChange, object: nil)
            }
        }
    }
    
    @objc
    private func handleUpDidTapped() {
        guard let currentIndex = articles?.firstIndex(of: article), let nextArticle = articles?[currentIndex - 1] else {
            return
        }
        article = nextArticle
        setElements(article: article)
    }
    @objc
    private func handleDownDidTapped() {
        guard let currentIndex = articles?.firstIndex(of: article), let nextArticle = articles?[currentIndex + 1] else {
            return
        }
        article = nextArticle
        setElements(article: article)
    }
    
    private func configureReadArticleButton() {
        readArticleButton.addTarget(self, action: #selector(handleReadArticleButtonDidTapped), for: .touchUpInside)
    }
    
    @objc
    private func handleReadArticleButtonDidTapped(){
        guard let url = URL(string: article.url ?? "") else {
            presentWarningAlert(title: "Fehler", message: "Die URL konnte nicht geladen werden.")
            return
        }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: config)
        present(safariVC, animated: true)
    }
    
    private func configureUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view, considerSafeArea: true)
        scrollView.addSubview(contentView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.pinToEdges(of: scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView)
        stackView.pinToEdges(of: contentView, with: 10, considerSafeArea: true)
    }
    
    func setElements(article: Article){
        stackView.removeAllArrangedSubviews()
        stackView.addArrangedSubviews([titleLabel, imageView, infoLabel, contentLabel, readArticleButton])
        self.titleLabel.text = article.title
        self.contentLabel.text = article.content == nil || article.content == "" ? article.articleDescription : article.content
        self.infoLabel.text = "Autor: \(article.author ?? "N/A") / \(article.publishedAt?.getStringRepresention() ?? "N/A") Uhr"
        self.imageView.setImage(urlString: article.urlToImage)
        
        favoriteButton.image = PersistenceManager.shared.isArticleAlreadyFav(article: article) ? UIImage(systemName: "star.fill", withConfiguration: config) : UIImage(systemName: "star", withConfiguration: config)
    }

}
