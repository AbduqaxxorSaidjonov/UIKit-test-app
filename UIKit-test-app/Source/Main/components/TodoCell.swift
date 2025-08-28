//
//  TodoCell.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import UIKit

class TodoCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let userLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = .systemFont(ofSize: 14)
        userLabel.font = .systemFont(ofSize: 12)
        userLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [titleLabel, userLabel])
        stack.axis = .vertical
        stack.spacing = 2
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with todo: TodosModel) {
        titleLabel.text = todo.title
        userLabel.text = todo.user?.name ?? "Unknown"
    }
}
