//
//  SearchView.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI
import Combine



struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                NavigationLink(value: user) {
                    UserRow(user: user)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search GitHub users")
            .overlay {
                switch viewModel.status {
                case .idle:
                    ContentUnavailableView.search(text: viewModel.searchText)
                case .loading:
                    ProgressView()
                case .failure:
                    ContentUnavailableView.search(text: viewModel.searchText)
                case .success:
                    EmptyView()
                }
            }
            .navigationDestination(for: GithubUser.self) { user in
                ProfileView(user: user)
            }
            
        }
    }
    
    
}

struct UserRow: View {
    let user: GithubUser
    
    var body: some View {
        HStack(spacing: 12) {
            AvatarView(url: user.avatarUrl, size: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(user.login)
                    .font(.subheadline).fontWeight(.semibold)
                Text("github.com/\(user.login)")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SearchView()
}

