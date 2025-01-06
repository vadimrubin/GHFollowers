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
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
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
