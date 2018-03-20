//
//  ResultsTableViewCell.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit

private let kPaddingConstant: CGFloat = 8
private let kImageViewSideLength: CGFloat = 40

class ResultsTableViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImageViewConstraints()
        setupTitleLabelConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageViewConstraints()
        setupTitleLabelConstraints()
    }

    var viewModel: PostViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }
}

private extension ResultsTableViewCell {
    func setupImageViewConstraints() {
        thumbnailImageView.backgroundColor = .red

        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: kPaddingConstant),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kPaddingConstant),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: kImageViewSideLength),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: kImageViewSideLength),
        ])
    }

    func setupTitleLabelConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: kPaddingConstant),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kPaddingConstant),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kPaddingConstant),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kPaddingConstant),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: thumbnailImageView.heightAnchor)
        ])
    }
}
