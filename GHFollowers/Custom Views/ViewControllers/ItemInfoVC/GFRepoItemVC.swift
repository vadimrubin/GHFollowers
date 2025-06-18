//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 09.12.2024.
//

import UIKit

//protocol showSafariViewDelegate { //это я делал "своим" способом, чтобы этот VC сообщал UserInfoVC, что кнопка нажата
//    func showSafariViewwww()
//}

protocol GFRepoItemVCDelegate {
    func didTapGitHubProfile(for user: User) //действие при нажатии кнопки "GitHub Profile". Открываем SafariView и показываем профиль по ссылке
}

//создаем GFRepoItemVC, который наследуется от GFItemInfoVC, соответственно у него есть все методы родительского класса
class GFRepoItemVC: GFItemInfoVC {
    
//    var delegate: showSafariViewDelegate? //это мне нужно было для своего Протокола
    var delegate: GFRepoItemVCDelegate?
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
//        configureButton() //тоже относится к своему протоколу
    }
    
    //настраиваем Элементы itemInfoViewOne и itemInfoViewTwo, в которых показываем раличные значения (repos и gists), но в одном стиле
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile") //+настраваем кнопку actionButton
    }
    
        //это тоже для моего Протокола
//    func configureButton() {
//        actionButton.addTarget(self, action: #selector(showSafariViewInMainVC), for: .touchUpInside)
//
//    }
   
    //переписываем действие кнопки - когда кнопка нажата, то USerInfoVC выполняет действие didTapGitHubProfile
    override func actionButtonTapped() {
//        delegatee.didTapGitHubProfile(for: user) //осталось от родительского протокола
        delegate?.didTapGitHubProfile(for: user)
    }
    
    //это тоже для моего Протокола
//    @objc func showSafariViewInMainVC() {
//        print("кнопку нажали")
//        delegate?.showSafariViewwww()
//    }
}
