//
//  AvatarView.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/21/26.
//

import SwiftUI

struct AvatarView: View {
    let url: String
    let size: CGFloat

    var body: some View {
        ZStack {
              AsyncImage(url: URL(string: url)) { image in
                    image
                          .resizable()
                          .scaledToFill()
              } placeholder: {
                    ProgressView()
              }
              .clipShape(Circle())
        }
        .frame(width: size, height: size)
    }

    private func color(for login: String) -> Color {
        let palette: [Color] = [.purple, .green, .orange, .pink, .blue, .teal, .indigo]
        let index = login.unicodeScalars.reduce(0) { $0 + Int($1.value) } % palette.count
        return palette[index]
    }
}
