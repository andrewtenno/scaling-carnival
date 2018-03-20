//
//  ResultsFetcherTests.swift
//  ThriveMarket-TestTests
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import XCTest

@testable import ThriveMarket_Test

class ResultsFetcherTests: XCTestCase {
    func testCanParsePage() {
        let dataFetcher = LocalDataFetcher()
        let resultsFetcher = ResultsFetcher(endpoint: URL(string: "http://google.com")!,
                                            dataFetcher: dataFetcher)

        resultsFetcher.fetchListings(afterPage: nil) { (result) in
            switch result {
            case .success(let listing):
                XCTAssertEqual(listing.page.children.count, 25)
            case .failure(let error):
                XCTFail("Should have succeeded but failed with error \(error)")
            }
        }
    }
}
