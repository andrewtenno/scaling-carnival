//
//  Model.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

struct Listing<T>: Decodable where T: Decodable {
    let page: Page<T>

    enum CodingKeys: String, CodingKey {
        case page = "data"
    }
}

struct Page<T>: Decodable where T: Decodable {
    let before: String?
    let after: String
    let children: [Child<T>]
}

struct Child<T>: Decodable where T: Decodable {
    let data: T

}

struct Post: Decodable {
    let id: String
    let title: String
    let thumbnail: URL?
    let subreddit: String
}

struct Comment: Decodable {
    let body: String
    let author: String
}
