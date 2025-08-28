//
//  TodoDetailsView.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 27/08/25.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    private let todo: TodosModel

    init(todo: TodosModel) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Todo Details"

        let titleLabel = UILabel()
        titleLabel.text = "Todo title: \(todo.titleUnwrapped)"
        let statusLabel = UILabel()
        statusLabel.text = "Completed: \((todo.completed ?? false) ? "✅" : "❌")"
        let userLabel = UILabel()
        userLabel.text = "User: \(todo.user?.name ?? "Unknown") \(todo.user?.username ?? "no Name")"
        let emailLabel = UILabel()
        emailLabel.text = "Email: \(todo.user?.email ?? "N/A")"

        let stack = UIStackView(arrangedSubviews: [titleLabel, statusLabel, userLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 8

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
