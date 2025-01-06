//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 09.10.2024.
//

import UIKit

protocol UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController /*,showSafariViewDelegate */ {
    

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    var userName: String!
    
    var nextUser: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUI()
        getUserInfo()  
    }
    
    func showSafariViewwww() {
        print("Что-то теперь работает")
        view.backgroundColor = .yellow
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        //создаем UIBarButtonItem - дефолтная Эпл кнопка Done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        //ставим кнопку Done на место rightBarButtonItem
        navigationItem.rightBarButtonItem = doneButton
    }

    // @objc метод для UIBarButtonItem - скрыть VC
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        
        for item in itemViews {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func getUserInfo() {
        //загружаем информацию по Юзеру через NetworkManager
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            //штука, нужная для [weak self]
            guard let self = self else { return }
            
            //результат запроса - это success или failure. Проходим по каждому варианту.
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User) {
        let reposVC = GFRepoItemVC(user: user)
        reposVC.delegatee = self
        self.add(childVC: reposVC, to: self.itemViewOne)
        
        self.nextUser = user.login
        let followersVC = GFFollowerItemVC(user: user)
        followersVC.delegatee = self
        self.add(childVC: followersVC, to: self.itemViewTwo)
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to the user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        //
    }

}
    
