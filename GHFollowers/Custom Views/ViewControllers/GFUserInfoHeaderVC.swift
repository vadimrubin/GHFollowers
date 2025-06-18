//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 10.10.2024.
//

import UIKit

//создаем отдельный UIViewController для верхнего блока UserInfoVC
class GFUserInfoHeaderVC: UIViewController {
    
    //инициализируем элементы, которые будут в UI
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitileLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GFSecondaryTitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GFSecondaryTitleLabel(fontSize: 18)
    let bioLabel = GFBodyLabel(textAlignment: .left)
    
    //нам необходим User, который мы будем указывать при обращении к GFUserInfoHeaderVC
    var user: User!
    
    //создаем кастомный init для GFUserInfoHeaderVC
    init(user: User!) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    //штатная фигня
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutUI()
        configureUIElements()
    }
    
    func configureUIElements() {
        //загрузить картинку для аватара
//        downloadAvatarImageView()
        avatarImageView.downloadImage(fromURL: user.avatarUrl)
        usernameLabel.text = user.login
        //name, location и bio - optional, поэтому указываем дефолтное значение
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? "No bio...😔"
        bioLabel.numberOfLines = 3
        //SFSymbol для значка локации
        locationImageView.image = SFSymbols.location
        //по дефолту SFSymbols синие, поэтому меняем цвет
        locationImageView.tintColor = .secondaryLabel
    }
    
    //эту функцию мы не используем в проекте, так как поменяли на avatarImageView.downloadImage(fromURL: user.avatarUrl)
    func downloadAvatarImageView() {
        NetworkManager.shared.downloadImage(from: user.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    func addSubviews() {
//        view.addSubview(avatarImageView)
//        view.addSubview(usernameLabel)
//        view.addSubview(nameLabel)
//        view.addSubview(locationImageView) 
//        view.addSubview(locationLabel)
//        view.addSubview(bioLabel)
        view.addSubviews(avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

}
