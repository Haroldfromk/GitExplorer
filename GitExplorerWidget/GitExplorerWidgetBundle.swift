//
//  GitExplorerWidgetBundle.swift
//  GitExplorerWidget
//
//  Created by Dongik Song on 5/29/26.
//

import WidgetKit
import SwiftUI

@main
struct GitExplorerWidgetBundle: WidgetBundle {
    var body: some Widget {
        SingleGitExplorerWidget()
        MultiGitExplorerWidget()
    }
}
