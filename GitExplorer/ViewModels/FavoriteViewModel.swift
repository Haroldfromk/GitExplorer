//
//  FavoriteViewModel.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/23/26.
//


import Foundation
import Combine

final class FavoriteViewModel: ObservableObject {
    
    @Published var names: [String] = []
    @Published var countdown = 30
    @Published var users = [GithubUser]()
    
    private var addSubject = PassthroughSubject<String, Never>()
    private var removeSubject = PassthroughSubject<String, Never>()
    private var throttleSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    private var timerCancellable: AnyCancellable?
    private let service = GitHubNetworkService()
    
    let watchConnectivity = WatchConnectivityService()
    
    init () {
        print("FavoriteViewModel init")
        if let savedArray = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] {
            names = savedArray
        }
        
        addSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                self?.names.append(id)
                UserDefaults.shared.set(self?.names, forKey: Constants.favoritesKey)
                Task {
                    try? await self?.asyncFetchFavoriteDataBefore()
                }
            }.store(in: &cancellables)
        
        removeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                self?.names.removeAll { $0 == id }
                UserDefaults.shared.set(self?.names, forKey: Constants.favoritesKey)
                Task {
                    try? await self?.asyncFetchFavoriteDataBefore()
                }
            }.store(in: &cancellables)
        
        throttleSubject
            .throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: false)
            .sink {[weak self] _ in
                self?.getData()
            }.store(in: &cancellables)
        
        $users
            .dropFirst()
            .sink { [weak self] users in
                self?.watchConnectivity.sendFavoriteUsers(users)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func reloadData() async throws {
        
        if let savedArray = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] {
            names = savedArray
        }
        
        try await asyncFetchFavoriteDataBefore()
    }
    
    
    func addToFavorite(id: String) {
        addSubject.send(id)
    }
    
    func removeToFavorite(id: String) {
        removeSubject.send(id)
    }
    
    // MARK: - Publisher
    func fetchFavoriteData() -> AnyPublisher<[GithubUser], Error>{
        let publisher = names.map { name in
            self.service.fetchGitUser(user: name)
        }
        return Publishers.MergeMany(publisher)
            .collect()
            .map({ result in
                result.flatMap { $0 }
            })
            .eraseToAnyPublisher()
    }
    
    func getData() {
        fetchFavoriteData()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] result in
                self?.users = result
            }.store(in: &cancellables)
    }
    
    // MARK: - Async/Await
    func asyncFetchFavoriteDataBefore() async throws {
        var result = [GithubUser]()
        for name in names {
            let data = try await service.asyncFetchGitUser(user: name)
            result.append(data)
        }
        users = result
    }
    
    func asyncFetchFavoriteData() async throws {
        var result = [GithubUser]()
        
        try await withThrowingTaskGroup(of: GithubUser.self) { group in
            for name in names {
                group.addTask {
                    return try await self.service.asyncFetchGitUser(user: name)
                }
            }
            
            for try await user in group {
                result.append(user)
            }
        }
        
        users = result
    }
    
    func refreshData(isRefresh: Bool) {
        if isRefresh {
            guard timerCancellable == nil else { return }
            
            timerCancellable = timer
                .sink { [weak self] _ in
                    guard let self else { return }
                    countdown -= 1
                    if countdown <= 0 {
                        Task {
                            try? await self.asyncFetchFavoriteDataBefore()
                        }
                        countdown = 30
                    }
                }
        } else {
            timerCancellable?.cancel()
            timerCancellable = nil
            countdown = 30
        }
    }
    
    func refreshDataThrottled() {
        throttleSubject.send()
    }
}
