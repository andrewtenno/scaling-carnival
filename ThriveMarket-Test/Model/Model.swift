//
//  Model.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

struct Listing: Decodable {
    let page: Page

    enum CodingKeys: String, CodingKey {
        case page = "data"
    }
}

struct Page: Decodable {
    let before: String?
    let after: String
    let children: [Child]
}

struct Child: Decodable {
    let post: Post

    enum CodingKeys: String, CodingKey {
        case post = "data"
    }
}

struct Post: Decodable {
    let id: String
    let title: String
    let thumbnail: URL?
    let subreddit: String
}
