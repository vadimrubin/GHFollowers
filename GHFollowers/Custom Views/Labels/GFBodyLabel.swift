//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 12.09.2024.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
//        super.init(frame: .zero) т.к. сделали convenience init, то эта строчка больше не работает, вместо неё код выше - self.init(frame: .zero)
        self.textAlignment = textAlignment
//        configure() и т.к. convenience init теперь, то configure здесь нам не нужно вызывать. self.init(frame: .zero) вызывает основной init на 12-15 строчках.
    }
    
    private func configure() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true //это нужно для dynamic type (чтобы размер текста менялся, если люди изменяют дефолный размер текста у себя в телефоне)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
