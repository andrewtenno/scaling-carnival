//
//  AppDelegate.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = createWindow()
        window?.makeKeyAndVisible()

        return true
    }
}

// MARK: Helpers

private func createWindow() -> UIWindow {
    let screenFrame = UIScreen.main.fixedCoordinateSpace.bounds
    let window = UIWindow(frame: screenFrame)
    let resultsViewController = ResultsTableViewController()
    resultsViewController.viewModelGenerator = createViewModelGenerator()
    let navigationController = UINavigationController(rootViewController: resultsViewController)
    window.rootViewController = navigationController

    return window
}

private func createViewModelGenerator() -> ListingViewModelGeneratable {
    let dataFetcher = RemoteDataFetcher(urlSession: .shared)
    let url = URL(string: "http://www.reddit.com/r/all/new.json")!
    let resultsFetcher = ResultsFetcher(endpoint: url, dataFetcher: dataFetcher)
    let viewModelGenerator = ViewModelGenerator(resultsFetcher: resultsFetcher)

    return viewModelGenerator
}
