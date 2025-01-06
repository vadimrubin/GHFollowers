//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 06.12.2024.
//

import UIKit

//создаем VC, который будет родителем для VСs, которые показывают информацию по Гитам и Фолловерам
//этот VC имеют основную структурную информацию и Layout
class GFItemInfoVC: UIViewController {
    //элементы itemInfoViewOne и itemInfoViewTwo будут собраны в UIStackView
    let stackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()
    
    var user: User!
    //delegatee - для связи между ChildVCs - GFRepoItemVC&GFFollowerItemVC c UserInfoVC
    var delegatee: UserInfoVCDelegate!
    
    //создаем кастомный init для GFItemsInfoVC
    init(user: User!) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgoundView()
        configureStackView()
        configureActionButton()
        layoutUI()
        
    }
    //настраиваем view
    private func configureBackgoundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    //настраиваем stackView
    private func configureStackView() {
        
        stackView.axis = .horizontal //элементы в stackView группируются горизонтально
        stackView.distribution = .equalSpacing //размещаются в stackView с одинаковым растоянием между ними
        
        //в stackView будет два View, которые будут показывать информацию в одинаковом стиле
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    //настраиваем кнопку
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside) //добавляем действие
    }
    
    @objc func actionButtonTapped() {} //в действии пока ничего. Действие будем override в childVC

    //конфигурируем UI
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }

}
