//
//  RemoteData.swift
//  SwiftUIPropertyWrapperTalk
//
//  Created by Donny Wals on 14/06/2022.
//

import Foundation
import SwiftUI

private struct URLSessionKey: EnvironmentKey {
    static let defaultValue: URLSession = {
        URLSession.shared
    }()
}

extension EnvironmentValues {
    var urlSession: URLSession {
        get { self[URLSessionKey.self] }
        set { self[URLSessionKey.self] = newValue }
    }
}

@propertyWrapper
struct RemoteData: DynamicProperty {
    @StateObject private var dataLoader = DataLoader()
    private let endpoint: Endpoint

    var wrappedValue: [Post] {
        dataLoader.loadedData
    }

    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }

    @Environment(\.urlSession) var urlSession

    func update() {
        if dataLoader.urlSession == nil || dataLoader.endpoint == nil {
            dataLoader.urlSession = urlSession
            dataLoader.endpoint = endpoint
        }

        dataLoader.fetchDataIfNeeded()
    }
}

class DataLoader: ObservableObject {
    @Published var loadedData: [Post] = []
    private var isLoadingData = false
    
    var urlSession: URLSession?
    var endpoint: RemoteData.Endpoint?
    
    init() { }
    
    func fetchDataIfNeeded() {
        guard let urlSession = urlSession, let endpoint = endpoint,
            !isLoadingData && loadedData.isEmpty else {
            return
        }
        
        isLoadingData = true
        let url = URL.for(endpoint)
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                /* ... */
                return
            }
            
            DispatchQueue.main.async {
                self.loadedData = try! JSONDecoder()
                    .decode([Post].self, from: data)
            }
            self.isLoadingData = false
        }.resume()
    }
}

extension RemoteData {
    enum Endpoint {
        case feed
    }
}

extension URL {
    static func `for`(_ endpoint: RemoteData.Endpoint) -> URL {
        return URL(string: "https://donnywals.com/wp-json/wp/v2/posts")!
    }
}

