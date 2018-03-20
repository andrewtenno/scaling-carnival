//
//  ResultsTableViewCell.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/19/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit
import Haneke

private let kPaddingConstant: CGFloat = 8
private let kImageViewSideLength: CGFloat = 40

class ResultsTableViewCell: UITableViewCell {
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.hnk_cacheFormat = imageCacheConfiguration

        return imageView
    }()

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
            guard let viewModel = viewModel else { return }

            titleLabel.text = viewModel.title
//            switch viewModel.thumbnail {
//            case .self:
//                imageView?.backgroundColor = .red
//            case .nsfw:
//                imageView?.backgroundColor = .black
//            case .image(let url):
//                imageView?.hnk_setImage(from: url)
//            case .unknown:
//                imageView?.backgroundColor = .blue
//            }
        }
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        thumbnailImageView.hnk_cancelSetImage()
        thumbnailImageView.backgroundColor = nil
    }
}

private extension ResultsTableViewCell {
    func setupImageViewConstraints() {
//        contentView.addSubview(thumbnailImageView)
//        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: kPaddingConstant),
//            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kPaddingConstant),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: kImageViewSideLength),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: kImageViewSideLength),
//        ])
    }

    func setupTitleLabelConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: kPaddingConstant),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: kPaddingConstant),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kPaddingConstant),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kPaddingConstant),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kPaddingConstant),
//            titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: thumbnailImageView.heightAnchor)
        ])
    }
}

private var imageCacheConfiguration: HNKCacheFormat = {
    let format = HNKCacheFormat(name: "com.thrivemarket-test.cache")!
    format.size = CGSize(width: kImageViewSideLength, height: kImageViewSideLength)
    format.scaleMode = .aspectFill;
    format.compressionQuality = 0.5;
    format.diskCapacity = 2 * 1024 * 1024; // 2MB
    format.preloadPolicy = .lastSession;

    return format
}()
