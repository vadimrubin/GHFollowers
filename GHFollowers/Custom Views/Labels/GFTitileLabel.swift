//
//  GFTitileLabel.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 12.09.2024.
//

import UIKit

class GFTitileLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        
//        super.init(frame: .zero) т.к. сделали convenience init, то эта строчка больше не работает, вместо неё код выше - self.init(frame: .zero)
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
//        configure() и т.к. convenience init теперь, то configure здесь нам не нужно вызывать. self.init(frame: .zero) вызывает основной init на 12-15 строчках.
    }
    
    private func configure() {
        textColor = .label
        //если лейбл слишком длинный, то размер уменьшится чтобы поместиться на экран
        adjustsFontSizeToFitWidth = true
        //но уменьшится не более чем на 10% чтобы продолжать выглядеть как лейбл
        minimumScaleFactor = 0.9
        //если лейбл всё ещё не помещается на экран, то в конце будут три точки ...
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
