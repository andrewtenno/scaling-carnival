//
//  ViewModelGenerator.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum ListingViewModelGenerationResult {
    case success([PostViewModel], String)
    case failure(Error)
}

protocol ListingViewModelGeneratable {
    func fetchListingViewModels(afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult) -> Void)
}

protocol CommentsViewModelGeneratable {
    func fetchCommentViewModels(afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult) -> Void)
}


class ViewModelGenerator {
    let resultsFetcher: ResultsFetchable

    init(resultsFetcher: ResultsFetchable) {
        self.resultsFetcher = resultsFetcher
    }
}

extension ViewModelGenerator: ListingViewModelGeneratable {
    func fetchListingViewModels(afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult) -> Void) {
        resultsFetcher.fetchListings(afterPage: page) { (result) in
            handleFetchListings(result: result, completion: completion)
        }
    }
}

// MARK: Helpers

private func handleFetchListings(result: ResultsFetchResult, completion: (ListingViewModelGenerationResult) -> Void) {
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
                             thumbnail: createThumbnail(fromPost: post),
                             commentsURL: createCommentsURL(fromPost: post))
    }), listing.page.after)
}

func createThumbnail(fromPost post: Post) -> Thumbnail {
    guard let url = post.thumbnail else { return .unknown }

    if (url.scheme == "http" || url.scheme == "https") {
        return .image(url)
    }

    switch url.absoluteString {
    case "self":
        return .self
    case "nsfw":
        return .nsfw
    case "default":
        return .default
    default:
        return .unknown
    }
}

func createCommentsURL(fromPost post: Post) -> URL {
    return URL(string: "http://reddit.com/r/\(post.subreddit)/comments/\(post.id)/.json")!
}
