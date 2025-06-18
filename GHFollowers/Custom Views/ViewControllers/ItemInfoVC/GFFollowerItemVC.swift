//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 11.12.2024.
//

import Foundation

//свой протокол
//protocol showFollowersListVCDelegateProtocol {
//    func showFollowersListVC()
//}

protocol GFFollowerItemVCDelegate {
    func didTapGetFollowers(for user: User)  //действие при нажатии кнопки "Get Followers". Переходим на FollowersListVC и показываем новый список followers по user
}

//создаем GFFollowerItemVC, который наследуется от GFItemInfoVC, соответственно у него есть все методы родительского класса
class GFFollowerItemVC: GFItemInfoVC {
    
//    var delegate: showFollowersListVCDelegateProtocol? // свой протокол
    var delegate: GFFollowerItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
//        configureButton() // свой протокол
    }
    
    //настраиваем Элементы itemInfoViewOne и itemInfoViewTwo, в которых показываем раличные значения (followers и following), но в одном стиле
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    //переписываем действие кнопки. Когда кнопка нажата, то GFFollowerItemVC сообщает delegatee (он объявлен в родительском классе), что кнопка нажата и можно выполнять действие didTapGetFollowers
    override func actionButtonTapped() {
//        delegatee.didTapGetFollowers(for: user) //это родительский протокол
        delegate?.didTapGetFollowers(for: user)
    }
    
    //мой Протокол
//    func configureButton() {
//        actionButton.addTarget(self, action: #selector(showFollowersList), for: .touchUpInside)
//
//    }

//    @objc func showFollowersList() {
//        print("кнопку нажали")
//        delegate?.showFollowersListVC()
//    }

}
