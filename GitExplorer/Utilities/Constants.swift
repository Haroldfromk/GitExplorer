//
//  Constants.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/24/26.
//

import Foundation

class Constants {
    static let token = "" // token here
    static let favoritesKey = "FavoriteNames"
}

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.co.harold.GitExplorer")!
    }
}
