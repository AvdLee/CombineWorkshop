//
//  Models.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 20/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//
//  As inspired by and copied from: https://medium.com/snowdog-labs/combine-framework-in-action-fb91fd101602

import Foundation

struct Repo: Decodable {
    var id: Int
    let owner: Owner
    let name: String
    let description: String?

    struct Owner: Decodable {
        let avatar: URL

        enum CodingKeys: String, CodingKey {
            case avatar = "avatar_url"
        }
    }
}

struct SearchResponse: Decodable {
    let items: [Repo]
}
