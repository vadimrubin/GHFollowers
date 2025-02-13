//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 12.02.2025.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    
    fileprivate var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showLoadingView() {
        //создаем view и добавляем его на основной view
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        //устанавлиаем, что он изначально прозрачный
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        //анимацией меняем прозрачность и делаем слегка прозрачным
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        //создаем activityIndicator и добавляем его на containerView
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //включаем activityIndicator
        activityIndicator.startAnimating()
    }
    
    //метод, которым убираем loading view
    func dismissLoadingView() {
        //обязательно это должно быть в main
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
