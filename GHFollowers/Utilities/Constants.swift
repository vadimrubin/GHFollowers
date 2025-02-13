//
//  Constants.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 11.10.2024.
//

import UIKit

enum SFSymbols {
    static let location = "mappin.and.ellipse"
    static let repos = "folder"
    static let gists = "text.alignleft"
    static let followers = "heart"
    static let following = "person.2"
}

enum Images {
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let ghLogo = UIImage(named: "gh-logo")
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneXand12Mini = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPhone12Pro = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12ProMaxAnd14Plus = idiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPhone14Pro = idiom == .phone && ScreenSize.maxLength == 852.0
    static let isiPhone14ProMax = idiom == .phone && ScreenSize.maxLength == 932.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0
    static let isiPhone16Pro = idiom == .phone && ScreenSize.maxLength == 874.0
    static let isiPhone16ProMax = idiom == .phone && ScreenSize.maxLength == 956.0
    
    static func isiPhoneXAspectRation() -> Bool {
        return isiPhoneXand12Mini || isiPhoneXsMaxAndXr
    }
}
