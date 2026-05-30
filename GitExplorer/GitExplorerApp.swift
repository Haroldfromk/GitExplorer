//
//  GitExplorerApp.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI

@main
struct GitExplorerApp: App {
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteViewModel)
                .onAppear {
                    favoriteViewModel.watchConnectivity.viewModel = favoriteViewModel
                }
        }
    }
}
