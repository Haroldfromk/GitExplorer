//
//  SharedView.swift
//  GitExplorerWidgetExtension
//
//  Created by Dongik Song on 5/29/26.
//

import SwiftUI

struct AvatarView: View {
    let avatarData: Data?
    let size: CGFloat

    var body: some View {
        ZStack {
            if let data = avatarData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
    }
}

//#Preview {
//    AvatarView()
//}

struct StatLabel: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 1) {
            Text("\(value)")
                .font(.system(size: 13, weight: .semibold))
            Text(label)
                .font(.system(size: 8))
                .foregroundStyle(.secondary)
        }
    }
}
