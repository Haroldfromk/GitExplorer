//
//  MultiGitExplorerWidget.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import WidgetKit
import SwiftUI

struct MultiProvider: TimelineProvider {
    func placeholder(in context: Context) -> MultiGitExplorerEntry {
        MultiGitExplorerEntry(date: Date(), users: MockData.mockUsers, avatarData: [Data(), Data()])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MultiGitExplorerEntry) -> ()) {
        Task {
            let names = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] ?? []
            var users: [GithubUser] = []
            var avatarDatas: [Data] = []
            
            do {
                if names.count >= 2 {
                    for name in names.prefix(2) {
                        let user = try await NetworkService.shared.asyncFetchGitUser(user: name)
                        let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                        users.append(user)
                        avatarDatas.append(avatarData ?? Data())
                    }
                } else if names.count == 1 {
                    let user = try await NetworkService.shared.asyncFetchGitUser(user: names[0])
                    let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                    users.append(user)
                    users.append(MockData.mockUsers[1])
                    avatarDatas.append(avatarData ?? Data())
                    avatarDatas.append(Data())
                } else {
                    users = MockData.mockUsers
                    avatarDatas = [Data(), Data()]
                }
            } catch {
                users = MockData.mockUsers
                avatarDatas = [Data(), Data()]
            }
            
            completion(MultiGitExplorerEntry(date: Date(), users: users, avatarData: avatarDatas))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let names = UserDefaults.shared.array(forKey: Constants.favoritesKey) as? [String] ?? []
            var users: [GithubUser] = []
            var avatarDatas: [Data] = []
            
            do {
                if names.count >= 2 {
                    for name in names.prefix(2) {
                        let user = try await NetworkService.shared.asyncFetchGitUser(user: name)
                        let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                        users.append(user)
                        avatarDatas.append(avatarData ?? Data())
                    }
                } else if names.count == 1 {
                    let user = try await NetworkService.shared.asyncFetchGitUser(user: names[0])
                    let avatarData = await NetworkService.shared.downloadImageData(from: user.avatarUrl)
                    users.append(user)
                    users.append(MockData.mockUsers[1])
                    avatarDatas.append(avatarData ?? Data())
                    avatarDatas.append(Data())
                } else {
                    users = MockData.mockUsers
                    avatarDatas = [Data(), Data()]
                }
            } catch {
                users = MockData.mockUsers
                avatarDatas = [Data(), Data()]
            }
            
            let entry = MultiGitExplorerEntry(date: .now, users: users, avatarData: avatarDatas)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(6 * 60 * 60)))
            completion(timeline)
        }
    }
}


struct MultiGitExplorerEntry: TimelineEntry {
    let date: Date
    let users: [GithubUser]
    let avatarData: [Data?]
}

struct MultiGitExplorerEntryView: View {
    var entry: MultiGitExplorerEntry
    
    var body: some View {
        MediumWidgetView(favorites: entry.users, avatarData: entry.avatarData)
    }
}

struct MultiGitExplorerWidget: Widget {
    let kind: String = "MultiGitExplorerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MultiProvider()) { entry in
            MultiGitExplorerEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("GitExplorer")
        .description("즐겨찾기 유저 정보를 홈 화면에서 확인합니다.")
        .supportedFamilies([.systemMedium])
    }
}
