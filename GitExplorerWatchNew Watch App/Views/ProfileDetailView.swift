//
//  ProfileDetailView.swift
//  GitExplorer Watch App
//
//  Created by Dongik Song on 5/28/26.
//

import SwiftUI

import SwiftUI

struct ProfileDetailView: View {
    let user: GithubUser
    
    // 나중에 API 연결 예정
    let repos: [GithubRepo] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                AvatarView(url: user.avatarUrl, size: 48)
                
                VStack(spacing: 2) {
                    Text(user.login)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    if let bio = user.bio {
                        Text(bio)
                            .font(.system(size: 10))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                
                HStack(spacing: 8) {
                    StatCard(value: user.publicRepos ?? 0, label: "repos")
                    StatCard(value: user.followers ?? 0, label: "followers")
                    StatCard(value: user.following ?? 0, label: "following")
                }
                
                if !repos.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Repositories")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(repos) { repo in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(repo.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.blue)
                                    .lineLimit(1)
                                HStack(spacing: 6) {
                                    if let lang = repo.language {
                                        Text(lang)
                                            .font(.system(size: 9))
                                            .foregroundStyle(.gray)
                                    }
                                    Label("\(repo.stargazersCount)", systemImage: "star")
                                        .font(.system(size: 9))
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(white: 0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
        }
        .navigationTitle(user.login)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct StatCard: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(Color(white: 0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
