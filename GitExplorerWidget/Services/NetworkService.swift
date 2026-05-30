//
//  NetworkService.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    func asyncFetchGitUser(user: String) async throws -> GithubUser {
        let url = URL(string: "https://api.github.com/users/\(user)")!
        let header = ["Authorization" : "\(Constants.token)"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedData = try JSONDecoder().decode(GithubUser.self, from: data)
        
        return decodedData
    }
    
    func downloadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
    
}
