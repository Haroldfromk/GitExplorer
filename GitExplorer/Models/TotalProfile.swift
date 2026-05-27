//
//  TotalProfile.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/22/26.
//

import Foundation

struct TotalProfile {
    let repos: [GithubRepo]
    let followers: [GithubUser]
    let followings: [GithubUser]
}

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

// MARK: - RepoModel
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
