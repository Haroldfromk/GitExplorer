//
//  FavoritesView.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI

struct FavoriteView: View {
    
    @State private var countdown = 30
    @EnvironmentObject var viewModel: FavoriteViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: 32, height: 32)
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("자동 갱신 중")
                                .font(.subheadline).fontWeight(.semibold)
                            
                            Text("다음 갱신까지 \(viewModel.countdown)초")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)

                    ProgressView(value: Double(30 - viewModel.countdown) / 30.0)
                        .progressViewStyle(.linear)
                        .tint(.blue)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                }

                Section(header: Text("즐겨찾기 \(viewModel.names.count)명")) {
                    if viewModel.names.isEmpty {
                        ContentUnavailableView(
                            "즐겨찾기 없음",
                            systemImage: "star.slash",
                            description: Text("검색 후 별표를 눌러 추가하세요.")
                        )
                    } else {
                        ForEach(viewModel.users, id: \.self) { user in
                            NavigationLink(value: user) {
                                FavoriteRow(user: user)
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                viewModel.removeToFavorite(id: viewModel.names[index])
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            try await viewModel.asyncFetchFavoriteDataBefore()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .navigationDestination(for: GithubUser.self) { login in
                ProfileView(user: login)
            }
            .onAppear {
                viewModel.refreshData(isRefresh: true)
            }
            .onDisappear {
                viewModel.refreshData(isRefresh: false)
            }
        }
    }
}

fileprivate struct FavoriteRow: View {
    let user: GithubUser

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(url: user.avatarUrl, size: 40)
            LazyVStack(alignment: .leading, spacing: 2) {
                Text(user.login)
                    .font(.subheadline).fontWeight(.semibold)
                Text("\(user.publicRepos ?? 0) repos · \(user.followers ?? 0) followers")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
        }
        .padding(.vertical, 2)
    }
}
