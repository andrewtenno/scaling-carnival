//
//  ViewModelGenerator.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum ListingViewModelGenerationResult<T> {
    case success([T], String)
    case failure(Error)
}

protocol ListingViewModelGeneratable {
    func fetchPostViewModels(afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult<PostViewModel>) -> Void)
    func fetchCommentViewModels(forURL url: URL, afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult<CommentViewModel>) -> Void)
}

class ViewModelGenerator {
    let resultsFetcher: ResultsFetchable

    init(resultsFetcher: ResultsFetchable) {
        self.resultsFetcher = resultsFetcher
    }
}

extension ViewModelGenerator: ListingViewModelGeneratable {
    func fetchPostViewModels(afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult<PostViewModel>) -> Void) {
        resultsFetcher.fetchListings(afterPage: page) { (result) in
            handleFetchPosts(result: result, completion: completion)
        }
    }

    func fetchCommentViewModels(forURL url: URL, afterPage page: String?, completion: @escaping (ListingViewModelGenerationResult<CommentViewModel>) -> Void) {
        resultsFetcher.fetchComments(forURL: url, afterPage: page) { (result) in
            handleFetchComments(result: result, completion: completion)
        }
    }
}

// MARK: Helpers

private func handleFetchPosts(result: ListingFetchResult<Post>, completion: (ListingViewModelGenerationResult<PostViewModel>) -> Void) {
    switch result {
    case .success(let listing):
        let (viewModels, nextPageToFetch) = createPostViewModels(fromListing: listing)
        completion(.success(viewModels, nextPageToFetch))
    case .failure(let error):
        completion(.failure(error))
    }
}

private func createPostViewModels(fromListing listing: Listing<Post>) -> ([PostViewModel], String) {
    return (listing.page.children.map({ (child) -> PostViewModel in
        let post = child.data

        return PostViewModel(title: post.title,
                             thumbnail: createThumbnail(fromPost: post),
                             commentsURL: createCommentsURL(fromPost: post))
    }), listing.page.after)
}

private func createThumbnail(fromPost post: Post) -> Thumbnail {
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

private func createCommentsURL(fromPost post: Post) -> URL {
    return URL(string: "http://reddit.com/r/\(post.subreddit)/comments/\(post.id)/.json")!
}

private func handleFetchComments(result: ListingFetchResult<Comment>, completion: (ListingViewModelGenerationResult<CommentViewModel>) -> Void) {
    switch result {
    case .success(let listing):
        let (viewModels, nextPageToFetch) = createCommentViewModels(fromListing: listing)
        completion(.success(viewModels, nextPageToFetch))
    case .failure(let error):
        completion(.failure(error))
    }
}

private func createCommentViewModels(fromListing listing: Listing<Comment>) -> ([CommentViewModel], String) {
    return (listing.page.children.map({ (child) -> CommentViewModel in
        let comment = child.data

        return CommentViewModel(user: comment.author,
                                text: comment.body)
    }), listing.page.after)
}
