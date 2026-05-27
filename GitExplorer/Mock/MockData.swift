//
//  MockData.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import Foundation

struct MockData {
    static let users: [GithubUser] = [
        GithubUser(id: 1, login: "Haroldfromk", avatarUrl: "", htmlUrl: "", name: "Harold", bio: "iOS Developer · Swift lover", publicRepos: 42, followers: 128, following: 56),
        GithubUser(id: 2, login: "twostraws",   avatarUrl: "", htmlUrl: "", name: "Paul Hudson", bio: "Author of Hacking with Swift", publicRepos: 120, followers: 8200, following: 10),
        GithubUser(id: 3, login: "kodecocodes", avatarUrl: "", htmlUrl: "", name: "Kodeco", bio: "Mobile development tutorials", publicRepos: 88, followers: 3100, following: 5),
        GithubUser(id: 4, login: "harold-dev",  avatarUrl: "", htmlUrl: "", name: nil, bio: nil, publicRepos: 12, followers: 4, following: 3),
    ]

    static let repos: [GithubRepo] = [
        GithubRepo(id: 1, name: "AppWorkspace", htmlURL: "", description: "A collection of useful iOS utility features", stargazersCount: 15, language: "Swift", forksCount: 2),
        GithubRepo(id: 2, name: "DailyTracker", htmlURL: "", description: "Simple habit and routine management application", stargazersCount: 10, language: "Swift", forksCount: 1),
        GithubRepo(id: 3, name: "ReactiveSandbox", htmlURL: "", description: "Asynchronous data stream handling examples", stargazersCount: 6, language: "Swift", forksCount: 0),
        GithubRepo(id: 4, name: "TechArchive", htmlURL: "", description: "Personal development records and documentation", stargazersCount: 3, language: "Markdown", forksCount: 0),
    ]

    static let followers: [GithubUser] = [
        GithubUser(id: 10, login: "swift_dev", avatarUrl: "", htmlUrl: "", name: "Swift Dev", bio: "Swift enthusiast", publicRepos: 30, followers: 200, following: 50),
        GithubUser(id: 11, login: "ios_maker", avatarUrl: "", htmlUrl: "", name: "iOS Maker", bio: "Building apps for fun", publicRepos: 15, followers: 80, following: 20),
        GithubUser(id: 12, login: "combine_fan", avatarUrl: "", htmlUrl: "", name: nil, bio: nil, publicRepos: 8, followers: 12, following: 5),
    ]

    static let following: [GithubUser] = [
        GithubUser(id: 20, login: "pointfreeco", avatarUrl: "", htmlUrl: "", name: "Point-Free", bio: "Functional programming in Swift", publicRepos: 45, followers: 5200, following: 3),
        GithubUser(id: 21, login: "apple", avatarUrl: "", htmlUrl: "", name: "Apple", bio: nil, publicRepos: 90, followers: 12000, following: 0),
        GithubUser(id: 22, login: "realm", avatarUrl: "", htmlUrl: "", name: "Realm", bio: "Mobile database", publicRepos: 60, followers: 3800, following: 10),
    ]

    static let favorites: [GithubUser] = [users[0], users[1], users[2]]
}
