//
//  NewsTVC.swift
//  Newsapp
//
//  Created by Domenic Moran on 09.08.22.
//

import UIKit

class NewsTVC: UITableViewCell {
    
    static let reuseID = "newsCell"
    
    private let titleLabel = NewsLabel(fontStyle: .headline, numberOfLines: 0)
    
    private let subtitleLabel = NewsLabel(fontStyle: .subheadline, numberOfLines: 0)
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        contentView.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)

        titleStackView.pinToEdges(of: contentView, with: 10)
    }
    
   func setCell(articel: Article) {
       titleLabel.text = articel.title ?? "N/A"
       subtitleLabel.text = "\(articel.publishedAt?.getStringRepresention() ?? "N/A") Uhr"

   }
}
