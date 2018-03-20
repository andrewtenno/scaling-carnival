//
//  ResultsFetcher.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum ListingFetchResult<T> where T: Decodable {
    case success(Listing<T>)
    case failure(Error)
}

protocol ResultsFetchable {
    func fetchListings(afterPage page: String?, completion: @escaping (ListingFetchResult<Post>) -> Void)
    func fetchComments(forURL url: URL, afterPage page: String?, completion: @escaping (ListingFetchResult<Comment>) -> Void)
}

class ResultsFetcher {
    private let endpoint: URL
    private let dataFetcher: DataFetchable
    private let jsonDecoder = JSONDecoder()

    init(endpoint: URL, dataFetcher: DataFetchable) {
        self.endpoint = endpoint
        self.dataFetcher = dataFetcher
    }

    enum ResultsFetchError: Error {
        case unableToCreateURLRequest
    }
}

extension ResultsFetcher: ResultsFetchable {
    func fetchListings(afterPage page: String?, completion: @escaping (ListingFetchResult<Post>) -> Void) {
        do {
            let urlRequest = try createFetchListingsURLRequest(afterPage: page)
            dataFetcher.fetchData(forRequest: urlRequest, completion: { [weak self] (result) in
                guard let sSelf = self else { return }

                sSelf.handlePostListingDataFetch(result:result, completion: completion)
            })
        } catch {
            completion(.failure(error))
        }
    }

    func fetchComments(forURL url: URL, afterPage page: String?, completion: @escaping (ListingFetchResult<Comment>) -> Void) {
        do {
            let urlRequest = try createFetchCommentsURLRequest(forURL: url, afterPage: page)
            dataFetcher.fetchData(forRequest: urlRequest, completion: { [weak self] (result) in
                guard let sSelf = self else { return }

                sSelf.handleCommentsListingDataFetch(result:result, completion: completion)
            })
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: Helpers

private extension ResultsFetcher {
    func createFetchListingsURLRequest(afterPage page: String?) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: endpoint, resolvingAgainstBaseURL: true) else {
            throw ResultsFetchError.unableToCreateURLRequest
        }

        if let page = page {
            let queryItemsToAdd = [ URLQueryItem(name: "after", value: page) ]
            if let queryItems = urlComponents.queryItems {
                urlComponents.queryItems = queryItems + queryItemsToAdd
            } else {
                urlComponents.queryItems = queryItemsToAdd
            }
        }

        guard let url = urlComponents.url else {
            throw ResultsFetchError.unableToCreateURLRequest
        }
        return URLRequest(url: url)
    }

    func handlePostListingDataFetch(result: DataFetchResult, completion: (ListingFetchResult<Post>) -> Void) {
        switch result {
        case .success(let data):
            do {
                let page = try jsonDecoder.decode(Listing<Post>.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

private extension ResultsFetcher {
    func createFetchCommentsURLRequest(forURL url: URL, afterPage page: String?) throws -> URLRequest {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw ResultsFetchError.unableToCreateURLRequest
        }

        if let page = page {
            let queryItemsToAdd = [ URLQueryItem(name: "after", value: page) ]
            if let queryItems = urlComponents.queryItems {
                urlComponents.queryItems = queryItems + queryItemsToAdd
            } else {
                urlComponents.queryItems = queryItemsToAdd
            }
        }

        guard let url = urlComponents.url else {
            throw ResultsFetchError.unableToCreateURLRequest
        }
        return URLRequest(url: url)
    }

    func handleCommentsListingDataFetch(result: DataFetchResult, completion: (ListingFetchResult<Comment>) -> Void) {
        switch result {
        case .success(let data):
            do {
                let comment = try jsonDecoder.decode(Listing<Comment>.self, from: data)
                completion(.success(comment))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
