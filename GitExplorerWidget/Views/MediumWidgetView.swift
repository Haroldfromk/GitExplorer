//
//  MediumWidgetView.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import SwiftUI

struct MediumWidgetView: View {
    let favorites: [GithubUser]
    let avatarData: [Data?]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(favorites.enumerated()), id: \.element.id) { index, user in
                UserCell(user: user, avatarData: index < avatarData.count ? avatarData[index] : nil)
                if index < favorites.count - 1 {
                    Divider()
                }
            }
        }
        .padding(14)
        .overlay(alignment: .bottomLeading) {
            Text("GitExplorer")
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
                .padding(.leading, 14)
                .padding(.bottom, 10)
        }
    }
}
//#Preview {
//    MediumWidgetView()
//}

fileprivate struct UserCell: View {
    let user: GithubUser
    let avatarData: Data?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                AvatarView(avatarData: avatarData, size: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.login)
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                    if let bio = user.bio {
                        Text(bio)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            HStack(spacing: 6) {
                StatLabel(value: user.publicRepos ?? 0, label: "repos")
                StatLabel(value: user.followers ?? 0, label: "followers")
                StatLabel(value: user.following ?? 0, label: "following")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
    }
}


