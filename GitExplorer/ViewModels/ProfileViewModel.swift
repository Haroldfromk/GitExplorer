//
//  ProfileViewModel.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/22/26.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    
    @Published var totalProfile = TotalProfile(
        repos: [],
        followers: [],
        followings: []
    )
    
    private let service = GitHubNetworkService()
    private var cancellables: Set<AnyCancellable> = []
    
    init(requestUser: GithubUser) {
        Publishers.CombineLatest3(service.fetchGitData(requestType: .repo(requestUser.login))
            .catch { error -> Just<[GithubRepo]> in
                print(error)
                return Just([])
            }, service.fetchGitData(requestType: .follower(requestUser.login))
            .catch { error -> Just<[GithubUser]> in
                print(error)
                return Just([])
            }, service.fetchGitData(requestType: .following(requestUser.login))
            .catch { error -> Just<[GithubUser]> in
                print(error)
                return Just([])
            })
        .receive(on: DispatchQueue.main)
        .sink { [weak self] repos, followers, followings in
            self?.totalProfile = TotalProfile(repos: repos,
                                              followers: followers,
                                              followings: followings)
        }.store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
}
