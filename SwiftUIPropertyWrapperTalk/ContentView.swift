//
//  ContentView.swift
//  SwiftUIPropertyWrapperTalk
//
//  Created by Donny Wals on 14/06/2022.
//

import SwiftUI

struct PostsView: View {
    @RemoteData(endpoint: .feed) var feed: [Post]
    
    var body: some View {
        List(feed) { post in
            Text(post.title)
        }
    }
}
