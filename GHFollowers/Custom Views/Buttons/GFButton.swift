//
//  GFButton.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 29.08.2024.
//

import UIKit

// класс GFButton создается, наследуясь от UIButton
class GFButton: UIButton {

    override init(frame: CGRect) {
        //сначала нам нужно вызвать весь функионал UIButton, который был создан Эппл для нас, через super.init
        super.init(frame: frame)
        configure()
        //после можно писать уже свой кастомный код для GFButton
        
    }
    
    //эта часть кода нужна, когда мы наследуемся от UI класса для Storyboard. В нашем проекте нет Storyboard, но эта штука всё-равно просто должна быть
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //переписываем init, чтобы когда добавлять кнопку во VC мы могли там указать только бэкграунд и тайтл, в остальном кнопка всегда будет одинаковая
    convenience init(backgroudColor: UIColor, title: String) {
        //эта строчка нужно просто для инициализации, в дальнейшем мы установим frame для кнопки, когда будем создавать constraints
//        super.init(frame: .zero) - убираем, т.к. convenience init
        self.init(frame: .zero)
        //self. - здесь означает GFButton.
        self.backgroundColor = backgroudColor
        self.setTitle(title, for: .normal)
//        configure() - убираем, т.к. convenience init
    }
    
    //кастомный код для кнопки
    //private - означает, что функция может быть вызвана только в классе GFButton для того, чтобы, когда в других VC мы вызывали GFButton, у нас не было возможности конфигурировать кнопку, эта возможность должна быть только здесь
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        //хотим использовать Auto Layout
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
}
