//
//  ViewModelGenerator.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum ViewModelGenerationResult {
    case success([PostViewModel], String)
    case failure(Error)
}

protocol ViewModelGeneratable {
    func fetchViewModels(afterPage page: String?, completion: @escaping (ViewModelGenerationResult) -> Void)
}

class ViewModelGenerator {
    let resultsFetcher: ResultsFetchable

    init(resultsFetcher: ResultsFetchable) {
        self.resultsFetcher = resultsFetcher
    }
}

extension ViewModelGenerator: ViewModelGeneratable {
    func fetchViewModels(afterPage page: String?, completion: @escaping (ViewModelGenerationResult) -> Void) {
        resultsFetcher.fetchListings(afterPage: page) { (result) in
            handleFetchListings(result: result, completion: completion)
        }
    }
}

private func handleFetchListings(result: ResultsFetchResult, completion: (ViewModelGenerationResult) -> Void) {
    switch result {
    case .success(let listing):
        let (viewModels, nextPageToFetch) = createViewModels(fromListing: listing)
        completion(.success(viewModels, nextPageToFetch))
    case .failure(let error):
        completion(.failure(error))
    }
}

func createViewModels(fromListing listing: Listing) -> ([PostViewModel], String) {
    return (listing.page.children.map({ (child) -> PostViewModel in
        let post = child.post

        return PostViewModel(title: post.title,
                             thumbnail: createThumbnail(fromPost: post))
    }), listing.page.after)
}

func createThumbnail(fromPost post: Post) -> Thumbnail {
    guard let url = post.thumbnail else { return .unknown }

    switch url.absoluteString {
    case "self":
        return .self
    case "nsfw":
        return .nsfw
    default:
        return .image(url)
    }
}
