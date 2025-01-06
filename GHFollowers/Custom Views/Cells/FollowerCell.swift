//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 19.09.2024.
//

import UIKit

//cоздаем ячейку
class FollowerCell: UICollectionViewCell {
    
    //как и в Stryboard нам нужен reuseID
    static let reuseID = "FollowerCell"
    //клетка состоит из аватара и имени. Оба объекта кастомные
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitileLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //метод, нужный для того, чтобы передать данные в ячейку
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(from: follower.avatarUrl)
    }
    
    //конфигурируем ячейку
    private func configure() {
        //обязательно добавялем Subview
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        let padding: CGFloat = 8
        
        //констрейнты
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
