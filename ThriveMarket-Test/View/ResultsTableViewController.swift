//
//  ViewController.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit

private let kEstimatedCellHeight: CGFloat = 56.0

class ResultsTableViewController: UITableViewController {
    var viewModelGenerator: ListingViewModelGeneratable?
    var viewModels: [PostViewModel] = []
    private var nextPageToFetch: String?
    private var isLoadingNextPage = true

    private let reuseIdentifier = "reuseIdentifier"

    override var navigationItem: UINavigationItem {
        return UINavigationItem(title: "/r/new")
    }

    override func viewDidLoad() {
        tableView.estimatedRowHeight = kEstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchViewModels()
    }
}

private extension ResultsTableViewController {
    func fetchViewModels() {
        viewModelGenerator?.fetchPostViewModels(afterPage: nextPageToFetch, completion: { [weak self] (result) in
            self?.handleViewModalGenerationResult(result)
        })
    }

    private func handleViewModalGenerationResult(_ result: ListingViewModelGenerationResult<PostViewModel>) {
        switch result {
        case .success(let viewModels, let nextPageToFetch):
            OperationQueue.main.addOperation {
                self.isLoadingNextPage = false
                self.viewModels += viewModels
                self.nextPageToFetch = nextPageToFetch
                self.tableView.reloadData()
            }
        case .failure(let error):
            OperationQueue.main.addOperation {
                self.isLoadingNextPage = false
                self.presentError(error)
            }
        }
    }

    private func presentError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: "\(error)",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension ResultsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        if let resultCell = cell as? ResultsTableViewCell {
            resultCell.viewModel = viewModels[indexPath.row]
        }

        return cell
    }
}

// MARK: UITableViewDelegate

extension ResultsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.row]
        let commentsViewController = CommentsTableViewController()
        commentsViewController.url = viewModel.commentsURL
        commentsViewController.viewModelGenerator = viewModelGenerator
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}

// MARK: UIScrollViewDelegate

extension ResultsTableViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            loadNextPage()
        }
    }

    private func loadNextPage() {
        guard isLoadingNextPage == false else { return }

        isLoadingNextPage = true
        fetchViewModels()
    }
}
