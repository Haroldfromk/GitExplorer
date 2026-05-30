//
//  ContentView.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: FavoriteViewModel
    
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            FavoriteView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
        .task {
            do {
                try await viewModel.reloadData()
            } catch {
                print(error)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
