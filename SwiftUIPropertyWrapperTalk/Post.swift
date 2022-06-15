//
//  Post.swift
//  SwiftUIPropertyWrapperTalk
//
//  Created by Donny Wals on 14/06/2022.
//

import Foundation

public struct Post: Codable, Identifiable, Hashable, Equatable {
    public let id: Int
    public let title: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        
        let titleContainer = try container.nestedContainer(keyedBy: TitleCodingKeys.self, forKey: .title)
        self.title = try titleContainer.decode(String.self, forKey: .rendered)
    }
}

extension Post {
    enum CodingKeys: CodingKey {
        case id
        case title
    }
    
    enum TitleCodingKeys: CodingKey {
        case rendered
    }
}
