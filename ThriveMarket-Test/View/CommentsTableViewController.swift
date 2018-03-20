//
//  CommentsTableViewController.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/20/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit

private let kEstimatedCellHeight: CGFloat = 44.0

class CommentsTableViewController: UITableViewController {
    var url: URL?
    var viewModelGenerator: ListingViewModelGeneratable?
    var viewModels: [CommentViewModel] = []
    private var nextPageToFetch: String?
    private var isLoadingNextPage = true

    private let reuseIdentifier = "CommentsTableViewCell"

    override func viewDidLoad() {
        self.navigationItem.title = "Comments"
        tableView.estimatedRowHeight = kEstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchViewModels()
    }
}

private extension CommentsTableViewController {
    func fetchViewModels() {
        guard let url = url else { return }
        viewModelGenerator?.fetchCommentViewModels(forURL: url, afterPage: nextPageToFetch, completion: { [weak self] (result) in
            self?.handleViewModelGenerationResult(result)
        })
    }

    private func handleViewModelGenerationResult(_ result: ListingViewModelGenerationResult<CommentViewModel>) {
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

extension CommentsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        if let resultCell = cell as? CommentsTableViewCell {
            resultCell.viewModel = viewModels[indexPath.row]
        }

        return cell
    }
}

// MARK: UITableViewDelegate

extension CommentsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
