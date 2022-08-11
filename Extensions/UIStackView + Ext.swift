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
    func removeAllArrangedSubviews(){
        arrangedSubviews.forEach {
                self.removeArrangedSubview($0)
                NSLayoutConstraint.deactivate($0.constraints)
                $0.removeFromSuperview()
        }
    }
}
