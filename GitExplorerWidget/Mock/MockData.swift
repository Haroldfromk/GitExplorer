//
//  MockData.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import Foundation

struct MockData {
    static let mockUser = GithubUser(
        id: 1,
        login: "MockHarold",
        avatarUrl: "",
        name: "Harold",
        bio: "iOS Developer",
        publicRepos: 42,
        followers: 128,
        following: 56
    )
    
    static let mockUsers = [
        GithubUser(
            id: 1,
            login: "MockHarold",
            avatarUrl: "",
            name: "Harold",
            bio: "iOS Developer",
            publicRepos: 42,
            followers: 128,
            following: 56
        ),
        GithubUser(
            id: 2,
            login: "MockApple",
            avatarUrl: "",
            name: "Apple",
            bio: "We make iPhone",
            publicRepos: 80,
            followers: 9999,
            following: 0
        )
    ]
}
