//
//  GithubUser.swift
//  GitExplorerWatch Watch App
//
//  Created by Dongik Song on 5/28/26.
//

import Foundation

// MARK: - UserModel
struct GithubUser: Codable, Identifiable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
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
        case htmlUrl = "html_url"
        case publicRepos = "public_repos"
        case followers, following
        case bio
    }
}

struct GithubRepo: Codable, Identifiable {
    let id: Int
    let name: String
    let htmlURL: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let forksCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case htmlURL = "html_url"
        case description
        case stargazersCount = "stargazers_count"
        case language
        case forksCount = "forks_count"
    }
}

