//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 26.09.2024.
//

import UIKit

struct UIHelper {
    
    //создаем UICollectionViewFlowLayout с 3 столбцами
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        //ширина любого экрана
        let widht = view.bounds.width
        //оступы сверху/снизу + сбоку
        let padding: CGFloat = 12
        //растояние между столбцами
        let minimumItemSpacing: CGFloat = 10
        //доступное расстояние для всех столбцов
        let availableWidth = widht - (padding * 2) - (minimumItemSpacing * 2)
        //доступное расстояние для одного столбца
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        //устанавливаем отступы в UICollectionViewFlowLayout = padding
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        //itemWidth + 40 - это запас для лейбла
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}
