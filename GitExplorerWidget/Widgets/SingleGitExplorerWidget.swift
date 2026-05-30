//
//  SingleGitExplorerWidget.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import WidgetKit
import SwiftUI

struct SingleProvider: TimelineProvider {
    func placeholder(in context: Context) -> SingleGitExplorerEntry {
        SingleGitExplorerEntry(date: Date(), user: MockData.mockUser, avatarData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleGitExplorerEntry) -> ()) {
        Task {
            do {
                let names = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] ?? []
                let firstName = names.first ?? "haroldfromk"
                let user = try await NetworkService.shared.asyncFetchGitUser(user: firstName)
                let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                completion(SingleGitExplorerEntry(date: Date(), user: user, avatarData: avatarData))
            } catch {
                completion(SingleGitExplorerEntry(date: Date(), user: MockData.mockUser, avatarData: nil))
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let names = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] ?? []
                let firstName = names.first ?? "haroldfromk"
                let user = try await NetworkService.shared.asyncFetchGitUser(user: firstName)
                let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                let entry = SingleGitExplorerEntry(date: .now, user: user, avatarData: avatarData)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(6 * 60 * 60)))
                completion(timeline)
            } catch {
                let entry = SingleGitExplorerEntry(date: .now, user: MockData.mockUser, avatarData: nil)
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(6 * 60 * 60)))
                completion(timeline)
            }
        }
    }

}

struct SingleGitExplorerEntry: TimelineEntry {
    let date: Date
    let user: GithubUser
    let avatarData: Data?
}

struct SingleGitExplorerEntryView: View {
    var entry: SingleGitExplorerEntry
    
    var body: some View {
        SmallWidgetView(user: entry.user, avatarData: entry.avatarData)
    }
}

struct SingleGitExplorerWidget: Widget {
    let kind: String = "SingleGitExplorerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleProvider()) { entry in
            SingleGitExplorerEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("GitExplorer")
        .description("즐겨찾기 유저 정보를 홈 화면에서 확인합니다.")
        .supportedFamilies([.systemSmall])
    }
}
