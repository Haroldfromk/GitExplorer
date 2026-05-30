//
//  SmallWidgetView.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import SwiftUI

struct SmallWidgetView: View {
    let user: GithubUser?
    let avatarData: Data?
    
    var body: some View {
        if let user {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    AvatarView(avatarData: avatarData, size: 36)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(user.login)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(1)
                        if let bio = user.bio {
                            Text(bio)
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                HStack {
                    StatLabel(value: user.publicRepos ?? 0, label: "repos")
                    Spacer()
                    StatLabel(value: user.followers ?? 0, label: "followers")
                    Spacer()
                    StatLabel(value: user.following ?? 0, label: "following")
                }
                
                Spacer()
                
                Text("GitExplorer")
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
        } else {
            Text("즐겨찾기 없음")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    SmallWidgetView(user: MockData.mockUser, avatarData: nil)
}

