//
//  GithubUser.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import Foundation

struct GithubUser: Codable, Identifiable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    var name: String?
    var bio: String?
    var publicRepos: Int?
    var followers: Int?
    var following: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case name
        case publicRepos = "public_repos"
        case followers, following
        case bio
    }
}
