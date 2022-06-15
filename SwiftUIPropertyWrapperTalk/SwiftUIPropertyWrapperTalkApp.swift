//
//  SwiftUIPropertyWrapperTalkApp.swift
//  SwiftUIPropertyWrapperTalk
//
//  Created by Donny Wals on 14/06/2022.
//

import SwiftUI

@main
struct SwiftUIPropertyWrapperTalkApp: App {
    var body: some Scene {
        WindowGroup {
            PostsView()
                .environment(\.urlSession, URLSession.shared)
        }
    }
}
