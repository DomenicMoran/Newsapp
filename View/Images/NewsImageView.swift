//
//  NewsImageView.swift
//  Newsapp
//
//  Created by Domenic Moran on 10.08.22.
//

import UIKit

class NewsImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setImage(urlString: String?) {
        image = nil
        NetworkManager.shared.downloadImage(from: urlString) { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}
