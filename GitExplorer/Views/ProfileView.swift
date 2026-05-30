//
//  ProfileView.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI

struct ProfileView: View {
    let user: GithubUser
    @State private var selectedSegment = 0
    @State private var isFavorite = false
    @State private var isFollowing = false
    
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    
    init(user: GithubUser) {
        self.user = user
        _viewModel = StateObject(wrappedValue: ProfileViewModel(requestUser: user))
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    AvatarView(url: user.avatarUrl, size: 72)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.login)
                            .font(.headline)
                        if let bio = user.bio {
                            Text(bio)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        HStack(spacing: 20) {
                            StatBadge(value: user.publicRepos ?? 0, label: "Repos")
                            StatBadge(value: user.followers ?? 0, label: "Followers")
                            StatBadge(value: user.following ?? 0, label: "Following")
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.vertical, 8)

//                Button {
//                    isFollowing.toggle()
//                } label: {
//                    Text(isFollowing ? "Following" : "Follow")
//                        .font(.subheadline).fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 8)
//                        .background(isFollowing ? Color(.systemGray5) : Color.blue)
//                        .foregroundStyle(isFollowing ? .primary : Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .buttonStyle(.plain)
//                .animation(.easeInOut(duration: 0.2), value: isFollowing)
            }

            Section {
                Picker("", selection: $selectedSegment) {
                    Text("Repos").tag(0)
                    Text("Followers").tag(1)
                    Text("Following").tag(2)
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }

            if selectedSegment == 0 {
                if viewModel.totalProfile.repos.isEmpty {
                    EmptyView()
                } else {
                    ForEach(viewModel.totalProfile.repos) { repo in
                        Link(destination: URL(string: repo.htmlURL)!) {
                            RepoRow(repo: repo)
                        }
                    }
                }
            } else if selectedSegment == 1 {
                ForEach(viewModel.totalProfile.followers) { follower in
                    Link(destination: URL(string: follower.htmlUrl)!) {
                        UserRow(user: follower)
                    }
                }
            } else {
                ForEach(viewModel.totalProfile.followings) { following in
                    Link(destination: URL(string: following.htmlUrl)!) {
                        UserRow(user: following)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(user.login)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isFavorite {
                        favoriteViewModel.removeToFavorite(id: user.login)
                    } else {
                        favoriteViewModel.addToFavorite(id: user.login)
                    }
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundStyle(isFavorite ? .yellow : .primary)
                }
            }
        }
        .onAppear {
            if favoriteViewModel.names.contains(user.login){
                isFavorite = true
            }
        }
        .onReceive(favoriteViewModel.$names) { names in
            isFavorite = names.contains(user.login)
        }
    }
}

fileprivate struct StatBadge: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.subheadline).fontWeight(.bold)
            Text(label)
                .font(.caption2).foregroundStyle(.secondary)
        }
    }
}

fileprivate struct RepoRow: View {
    let repo: GithubRepo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repo.name)
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.blue)
            if let desc = repo.description {
                Text(desc)
                    .font(.caption).foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack(spacing: 12) {
                if let lang = repo.language {
                    HStack(spacing: 4) {
                        Circle().fill(languageColor(lang)).frame(width: 8, height: 8)
                        Text(lang).font(.caption2).foregroundStyle(.secondary)
                    }
                }
                Label("\(repo.stargazersCount)", systemImage: "star")
                    .font(.caption2).foregroundStyle(.secondary)
                if repo.forksCount > 0 {
                    Label("\(repo.forksCount)", systemImage: "tuningfork")
                        .font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }

    func languageColor(_ lang: String) -> Color {
        switch lang.lowercased() {
        case "swift":    return Color(red: 0.94, green: 0.32, blue: 0.22)
        case "python":   return .blue
        case "markdown": return .gray
        default:         return .gray
        }
    }
}
