//
//  ResultsFetcher.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import Foundation

enum ResultsFetchResult {
    case success(Page)
    case failure(Error)
}

protocol ResultsFetchable {
    func fetchListings(afterPage page: String?, completion: @escaping (ResultsFetchResult) -> Void)
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
    func fetchListings(afterPage page: String?, completion: @escaping (ResultsFetchResult) -> Void) {
        do {
            let urlRequest = try createFetchListingsURLRequest(afterPage: page)
            dataFetcher.fetchData(forRequest: urlRequest, completion: { [weak self] (result) in
                guard let sSelf = self else { return }

                sSelf.handleDataFetch(result:result, completion: completion)
            })
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: Helpers

extension ResultsFetcher {
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

    func handleDataFetch(result: DataFetchResult, completion: (ResultsFetchResult) -> Void) {
        switch result {
        case .success(let data):
            do {
                let page = try jsonDecoder.decode(Page.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
