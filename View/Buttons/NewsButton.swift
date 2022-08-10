//
//  NewsButton.swift
//  Newsapp
//
//  Created by Domenic Moran on 10.08.22.
//

import UIKit

class NewsButton: UIButton {

    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 20
        
    }
}
