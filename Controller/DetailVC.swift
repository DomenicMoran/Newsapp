//
//  DetailVC.swift
//  Newsapp
//
//  Created by Domenic Moran on 10.08.22.
//

import UIKit

class DetailVC: UIViewController {
    
    private let titleLabel = NewsLabel(fontStyle: .headline, numberOfLines: 0)
    
    private let imageView = NewsImageView(frame: .zero)
    
    private let infoLabel = NewsLabel(fontStyle: .footnote, numberOfLines: 0, textAlignment: .center)
    
    private let contentLabel = NewsLabel(fontStyle: .body, numberOfLines: 0)
    
    private let readArticelButton = NewsButton(backgroundColor: .systemBlue, title: "Zum ganzen Artikel")
    
    private let stackView = UIStackView()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    var article: Article!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    init(article: Article){
        super.init(nibName: nil, bundle: nil)
        self.article = article
        configureUI()
        setElements(article: article)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        stackView.addArrangedSubviews([titleLabel, imageView, infoLabel, contentLabel, readArticelButton])
        
        contentView.addSubview(stackView)
        stackView.pinToEdges(of: contentView, with: 10, considerSafeArea: true)
    }
    
    func setElements(article: Article){
        self.titleLabel.text = article.title
        self.contentLabel.text = article.content
        self.infoLabel.text = "Autor: \(article.author ?? "N/A") / \(article.publishedAt?.getStringRepresention() ?? "N/A") Uhr"
        self.imageView.setImage(urlString: article.urlToImage)
    }

}
