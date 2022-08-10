//
//  UIView + Ext.swift
//  Newsapp
//
//  Created by Domenic Moran on 09.08.22.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView, with padding: CGFloat = 0, considerSafeArea: Bool = false){
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: considerSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor, constant: padding),
            self.leadingAnchor.constraint(equalTo: considerSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: considerSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor, constant: -padding),
            self.bottomAnchor.constraint(equalTo: considerSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor, constant: -padding)
        ])
    }
}
