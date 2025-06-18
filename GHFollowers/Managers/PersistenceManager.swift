//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 07.01.2025.
//

import Foundation

//варианты действий для PersistanceManager
enum PersistanceActionType {
    case add, remove
}

//создаем PersistanceManager, с помощью которого можно сохранять и выгружать данные из UserDefaults
//изначально PersistanceManager был создан с помощью enum (в обучении говорится, что импользование enum более предпочтительно нежели struct потому что нельзя создать пустой enum, а пустую srtuct можно). НО, непонятно, почему это нельзя сделать как class. Я попробовал поменять enum на class и вроде всё тоже работает. Пока оставляю enum, но этот кейс непонятен.
enum PersistanceManager {
    static private let defaults = UserDefaults.standard //enums не могут иметь stored properties, но могут иметь static stored properties. Static stored properties относятся к самому вышеиниц enum, а вот просто stored properties относятся к instance of class or struct (enums не могут иметь instances)
    //UserDefaults.standard - это синглтон UserDefaults
    
    //key по которому сохраняем значения в UserDefaults
    enum Keys {
        static let favorites = "favorites"
    }
    
    //основная func, которую используем при сохранении или удалении Fav followers в/из UserDefaults
    //при успешном кейсе функция ничего не возвращает (совершает действие внутри), при неуспешном - ошибку
    //мы передаем объект Follower и просим его либо сохранить в UserDefaults, либо удалить оттуда
    static func updateWith(follower: Follower, actionType: PersistanceActionType, completed: @escaping (ErrorMessages?) -> Void) {
        //1. мы выгружаем объекты (Favorites) из UserDefaults
        retrieveFavorites { result in //могут быть два варианта результата: success и failure
            switch result {
            case .success(var favorites): //получили какие-то объекты, либо nil
//                var retrievedFavorites = favorites //передаем эти объекты или nil во временную переменную
                switch actionType { //теперь в зависисости от actionType добавляем объект или удаляем
                case .add: //если кейс добавить
                    //проверяем нет ли среди выгруженных объектов нашего объекта, с которым хотим сделать дейстия
                    guard !favorites.contains(follower) else {
                        //если есть, то завершаем функцию и передаем ошибку
                        completed(.alreadyInFavorites)
                        return //выходим из функции
                    }
                    //если объект новый, то добавляем его во временуую переменную
                    favorites.append(follower)
                case .remove: //если кейс удалить
                    favorites.removeAll { $0.login == follower.login } //удаляем его, если условие по поиску сработает ($0.login == follower.login)
                }
                //запускаем функцию сохранения
                completed(save(followers: favorites))
                
            case .failure(let error): //получили ошибку, её и отдаем в completed
                completed(error)
            }
        }
    }
    
    //ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ДАННЫХ (В НАШЕМ СЛУЧАЕ "FAVORITES")
    //result type функция, которая возвращает либо success case - Follower, либо ошибку ErrorMessages
    //escaping необходим для того, чтобы результат функции "ушел" за саму функцию, так как получение данных может занять время, а UI в этом время не должен быть заморожен и само приложение не зависало
    static func retrieveFavorites(completed: @escaping (Result<[Follower], ErrorMessages>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else { //defaults.object(forKey: Keys.favorites) возвращает Any, поэтому нам нужно кастить объект в Дата (as? Data)
            completed(.success([])) //если данных нет, то этот кейс тоже .success и мы возвращаем пустой array
            return //выходим из функции
        }
        
        do {
            //JSONDecoder() - это объект, который преобразует data в наши объекты
            //JSONEncoder() - работает наоборот, преобразует наши объекты в data
            let decoder = JSONDecoder()
            //здесь мы хотим чтобы создался array из объектов Followers используя decoder.decode из favoritesData. FavoritesData - это то, что выше получили из guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            //УСПЕШНЫЙ РЕЗУЛЬТАТ ФУНКЦИИ retrieveFavorites.
//                completed(followers, nil)
            completed(.success(favorites))
        } catch {
            //тк мы используем выше try, то если try не удался, то мы уходим в блок catch и завершаем функцию с пустым результатом и ошибкой
            completed(.failure(.unableToFavorite))
            //второй вариант, как показать ошибку средствами Эппл (т.е. показать ошибку, которая формируется реально). Проблема в том, что эта ошибка может быть трудночитаема для юзера, но полезна для разработчика (поэтому её удобно в принт выводить)
//                completed(nil, error.localizedDescription)
        }
    }
    
    
    //ФУНКЦИЯ ДЛЯ СОХРАНЕНИЯ ДАННЫХ (FAVORITES)
    //функция возвращает ErrorMessages?, т.е. в успешном кейсе ErrorMessages = nil, т.е. мы успешно сохранили данные, поэтому в ErrorMessages? и есть знак "?". В неуспешном кейсе мы вовзращаем ошибку (ErrorMessages)
    static func save(followers: [Follower]) -> ErrorMessages? {
        do {
            let encoder = JSONEncoder() // нам нужен JSONEncoder
            let encodedFavorites = try encoder.encode(followers) //encoder преобразует объекты Followers в Data и сохр их в encodedFavorites
            defaults.set(encodedFavorites, forKey: Keys.favorites) //сохраняем данные в UserDefaults
            return nil //этот кейс успешный, данные мы сохранили выше, поэтому возвращаем nil
        } catch { //уходим в catch блок потому что try не удался
            return .unableToFavorite //соотвественно показываем эту ошибку
            //или эту, если хотим узнать от Эппл, что конкретно произошло
            //return error.localizedDescription
        }
    }
}
