//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 13.03.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) { //Эта штука называется Variadic Parameter. "UIView..." - мы говорим, что в параметр можем передать сразу несколько Views. Они объединятся в array, удобно для работы. 
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
