//
//  ViewModel.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum Thumbnail {
    case image(URL)
    case nsfw
    case `self`
    case unknown
    case `default`
}

struct PostViewModel {
    let title: String
    let thumbnail: Thumbnail
    let commentsURL: URL
}

struct CommentViewModel {
    let user: String
    let text: String
}
