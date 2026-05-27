//
//  GitHubNetworkService.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import Foundation
import Combine

enum GitHubRequest {
    case profile(String)
    case repo(String)
    case follower(String)
    case following(String)
    
    var url: URL {
        switch self {
        case .profile(let user):
            return URL(string: "https://api.github.com/users/\(user)")!
        case .repo(let user):
            return URL(string: "https://api.github.com/users/\(user)/repos")!
        case .follower(let user):
            return URL(string: "https://api.github.com/users/\(user)/followers")!
        case .following(let user):
            return URL(string: "https://api.github.com/users/\(user)/following")!
        }
    }
}

final class GitHubNetworkService: ObservableObject {
    
    // MARK: - Publisher
    func fetchGitUser(user: String) -> AnyPublisher<[GithubUser], Error> {
        let url = URL(string: "https://api.github.com/users/\(user)")!
        let header = ["Authorization" : "\(Constants.token)"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        
        let session = URLSession(configuration: .default)
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: GithubUser.self, decoder: JSONDecoder())
            .map({ [$0] })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Async/Await
    func asyncFetchGitUser(user: String) async throws -> GithubUser {
        let url = URL(string: "https://api.github.com/users/\(user)")!
        let header = ["Authorization" : "\(Constants.token)"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedData = try JSONDecoder().decode(GithubUser.self, from: data)

        return decodedData
    }
    
    func fetchGitData<T: Codable>(requestType: GitHubRequest) -> AnyPublisher<T, Error> {
        
        let url = requestType.url
        
        let header = ["Authorization" : "\(Constants.token)"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        
        let session = URLSession(configuration: .default)
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
