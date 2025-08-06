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
    convenience init(color: UIColor, title: String, systemImageName: String) {
        //эта строчка нужно просто для инициализации, в дальнейшем мы установим frame для кнопки, когда будем создавать constraints
//        super.init(frame: .zero) - убираем, т.к. convenience init
        self.init(frame: .zero)
        //self. - здесь означает GFButton.
//        self.backgroundColor = backgroudColor
//        self.setTitle(title, for: .normal)
        //заменяем верхние две строчки кода на следующий метод, для оптимизации
        set(color: color, title: title, systemImageName: systemImageName)
//        configure() - убираем, т.к. convenience init
    }
    
    //кастомный код для кнопки
    //private - означает, что функция может быть вызвана только в классе GFButton для того, чтобы, когда в других VC мы вызывали GFButton, у нас не было возможности конфигурировать кнопку, эта возможность должна быть только здесь
    private func configure() {
        configuration = .gray()
//        layer.cornerRadius = 10 // вместо этого используем configuration ниже
        configuration?.cornerStyle = .medium
//        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
//        setTitleColor(.white, for: .normal)
        //хотим использовать Auto Layout
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, systemImageName: String) {
//        self.backgroundColor = backgroundColor //меняем тоже на configuration
//        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
//        setTitle(title, for: .normal)
        configuration?.title = title
        
        //добавить cf-symbol к кнопке
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    
}
