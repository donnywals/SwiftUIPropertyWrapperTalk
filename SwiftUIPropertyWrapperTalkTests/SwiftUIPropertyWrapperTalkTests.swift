//
//  SwiftUIPropertyWrapperTalkTests.swift
//  SwiftUIPropertyWrapperTalkTests
//
//  Created by Donny Wals on 15/06/2022.
//

import XCTest
import SwiftUI
import Combine
@testable import SwiftUIPropertyWrapperTalk

class CustomWrapperTest: XCTestCase {
    let app = UIViewController()
    
    final func host<V: View>(_ view: V) {
        let hosting = UIHostingController(rootView: view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        app.addChild(hosting)
        app.view.addSubview(hosting.view)
        NSLayoutConstraint.activate([
            hosting.view.leadingAnchor.constraint(equalTo: app.view.leadingAnchor),
            hosting.view.topAnchor.constraint(equalTo: app.view.topAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: app.view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: app.view.bottomAnchor),
        ])
        app.view.layoutIfNeeded()
    }
}

struct SampleTestView: View {
    @RemoteData(endpoint: .feed) var feed: [Post]
    
    let resultSubject = PassthroughSubject<[Post], Never>()
    
    init() {
        print("init")
    }
    
    var body: some View {
        Text("This is just a test view...")
            .onAppear {
                print("on appear")
                resultSubject.send(feed)
            }
            .onChange(of: feed) { newFeed in
                print("on change: \(newFeed)")
                resultSubject.send(newFeed)
            }
    }
}

class SwiftUIPropertyWrapperTalkTests: CustomWrapperTest {

    var cancellables = Set<AnyCancellable>()

    func testRemoteDataIsEventuallyAvailable() throws {
        let view = SampleTestView()
        
        let expect = expectation(description: "expected data to be loaded")
        view.resultSubject.sink { posts in
            if !posts.isEmpty {
                expect.fulfill()
            }
        }.store(in: &cancellables)
        
        host(view.environment(\.urlSession, URLSession.shared))
        
        waitForExpectations(timeout: 1)
    }
}
