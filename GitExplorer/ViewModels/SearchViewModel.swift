//
//  SearchViewModel.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import Foundation
import Combine

enum Staus {
    case idle
    case loading
    case success([GithubUser])
    case failure
}

final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var users = [GithubUser]()
    
    var status: Staus = .idle
    
    private var cancellables: Set<AnyCancellable> = []
    private let service = GitHubNetworkService()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.status = .loading
            })
            .map { text in
                self.service.fetchGitUser(user: text)
                    .retry(2)
                    .replaceError(with: [])
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                if value.isEmpty {
                    self?.status = .failure
                } else {
                    self?.status = .success(value)
                }
                self?.users = value
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
}

