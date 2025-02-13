//
//  User.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 16.09.2024.
//

import Foundation

//создаем объект User, его параметры должны соответствовать тому, что мы получаем в Network Calls, названия переменных должны быть одинаковыми
struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date //раньше здесь был string  и мы преобразовывали его в Date
}
