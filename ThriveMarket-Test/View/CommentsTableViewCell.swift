//
//  CommentsTableViewCell.swift
//  ThriveMarket-Test
//
//  Created by Andrew Tenno on 3/20/18.
//  Copyright © 2018 Andrew Tenno. All rights reserved.
//

import UIKit

private let kPaddingConstant: CGFloat = 8

class CommentsTableViewCell: UITableViewCell {
    let userLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        return label
    }()
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserLabelConstraints()
        setupCommentLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUserLabelConstraints()
        setupCommentLabelConstraints()
    }
    
    var viewModel: CommentViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            userLabel.text = viewModel.user
            commentLabel.text = viewModel.text
        }
    }
    
    override func prepareForReuse() {
        userLabel.text = nil
        commentLabel.text = nil
    }
}

private extension CommentsTableViewCell {
    func setupUserLabelConstraints() {
        contentView.addSubview(userLabel)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kPaddingConstant),
            userLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: kPaddingConstant),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kPaddingConstant),
            ])
    }
    
    func setupCommentLabelConstraints() {
        contentView.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: kPaddingConstant),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: kPaddingConstant),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -kPaddingConstant),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -kPaddingConstant)
            ])
    }
}
