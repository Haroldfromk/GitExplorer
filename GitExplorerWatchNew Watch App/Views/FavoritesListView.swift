//
//  FavoritesListView.swift
//  GitExplorer Watch App
//
//  Created by Dongik Song on 5/28/26.
//

import SwiftUI

struct FavoritesListView: View {
    
    let favorites: [GithubUser]
    
    @EnvironmentObject var watchConnectivity: WatchConnectivityService

    var body: some View {
        
        NavigationStack {
                Group {
                    if favorites.isEmpty {
                        Text("No favorites yet.\nAdd some from the iOS app.")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    } else {
                        List {
                            ForEach(favorites) { user in
                                NavigationLink(destination: ProfileDetailView(user: user)) {
                                    HStack(spacing: 10) {
                                        AvatarView(url: user.avatarUrl, size: 28)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(user.login)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundStyle(.white)
                                            Text("\(user.publicRepos ?? 0) repos · \(user.followers ?? 0) followers")
                                                .font(.system(size: 10))
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(Color(white: 0.15))
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    let user = favorites[index].login
                                    watchConnectivity.users.remove(at: index)
                                    watchConnectivity.sendDeleteMessage(user)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)
            }
        
    }
}
