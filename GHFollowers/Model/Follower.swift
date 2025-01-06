//
//  Follower.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 16.09.2024.
//

import Foundation

//создаем объект Follower, его параметры должны соответствовать тому, что мы получаем в Network Calls, названия переменных должны быть одинаковыми
struct Follower: Codable, Hashable {
    //var в объекте Follower должны быть такие же, как и в json response
    var login: String
    var avatarUrl: String
}

//если мы хотим, чтобы свойству Hashable соответствовал не весь класс, а только какая-то переменная в нем, то можно использовать следующий код

//struct Follower: Codable, Hashable {
//
//    var login: String - делаем только эту переменную Hashable
//    var avatarUrl: String
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
//}
