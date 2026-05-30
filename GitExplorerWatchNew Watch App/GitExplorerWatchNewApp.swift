//
//  GitExplorerWatchNewApp.swift
//  GitExplorerWatchNew Watch App
//
//  Created by Dongik Song on 5/30/26.
//

import SwiftUI

@main
struct GitExplorerWatchNew_Watch_AppApp: App {
    @StateObject private var watchConnectivity = WatchConnectivityService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                FavoritesListView(favorites: watchConnectivity.users)
            }
            .environmentObject(watchConnectivity)
        }
    }
}
