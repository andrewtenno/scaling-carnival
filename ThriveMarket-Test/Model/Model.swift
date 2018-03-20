//
//  Model.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

struct Page: Decodable {
    let before: String?
    let after: String
    let children: [Post]
}

struct Post: Decodable {
    let title: String
    let thumbnail: URL?
}
