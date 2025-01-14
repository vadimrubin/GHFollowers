//
//  ErrorMessages.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 18.09.2024.
//

import Foundation

enum ErrorMessages: String, Error {
    case invalidUserName = "This username created an invalid request. Please try again"
    case unableToComplete = "Unnable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoting this user. Please try again later"
    case alreadyInFavorites = "You've already favorited this user"
}
