//
//  GFItemInfoView.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 03.12.2024.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {

    let sfSymbol = UIImageView()
    let label = GFTitileLabel(textAlignment: .left, fontSize: 14)
    let countingLabel = GFTitileLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(sfSymbol: String, label: String, countingLabel: String) {
        self.init(frame: .zero)
        self.sfSymbol.image = UIImage(systemName: sfSymbol)
        self.label.text = label
        self.countingLabel.text = countingLabel
//        configure()
    }
    
    private func configure() {
        addSubview(sfSymbol)
        addSubview(label)
        addSubview(countingLabel)
        
        sfSymbol.translatesAutoresizingMaskIntoConstraints = false
        sfSymbol.contentMode = .scaleAspectFill //изменить масштаб символа, чтобы заполнить view, где он находится
        sfSymbol.tintColor = .label
        
        
        NSLayoutConstraint.activate([
            sfSymbol.topAnchor.constraint(equalTo: topAnchor),
            sfSymbol.leadingAnchor.constraint(equalTo: leadingAnchor),
            sfSymbol.heightAnchor.constraint(equalToConstant: 20),
            sfSymbol.widthAnchor.constraint(equalToConstant: 20),
            
            label.centerYAnchor.constraint(equalTo: sfSymbol.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: sfSymbol.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 18),
            
            countingLabel.topAnchor.constraint(equalTo: sfSymbol.bottomAnchor, constant: 4),
            countingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countingLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            sfSymbol.image = UIImage(systemName: SFSymbols.repos)
            label.text = "Public Repos"
        case .gists:
            sfSymbol.image = UIImage(systemName: SFSymbols.gists)
            label.text = "Public Gists"
        case .followers:
            sfSymbol.image = UIImage(systemName: SFSymbols.followers)
            label.text = "Followers"
        case .following:
            sfSymbol.image = UIImage(systemName: SFSymbols.following)
            label.text = "Following"
        }
        countingLabel.text = String(count) 
    }
}
