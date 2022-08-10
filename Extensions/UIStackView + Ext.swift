//
//  UIStackView + Ext.swift
//  Newsapp
//
//  Created by Domenic Moran on 10.08.22.
//

import UIKit

extension UIStackView{
    func addArrangedSubviews(_ views: [UIView]){
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
    }
}
