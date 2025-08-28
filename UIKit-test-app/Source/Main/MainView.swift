//
//  ViewController.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 26/08/25.
//

import UIKit

class MainView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        view.backgroundColor = .systemBackground
        
        viewModel.delegate = self
        viewModel.getTodos()
        setupUI()
    }
    
    private func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search todos or users"
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredTodos.count : viewModel.todosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        let todo = viewModel.isSearching ? viewModel.filteredTodos[indexPath.row] : viewModel.getCurrentPageTodos()[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = viewModel.isSearching ? viewModel.filteredTodos[indexPath.row] : viewModel.getCurrentPageTodos()[indexPath.row]
        let detailsVC = TodoDetailsViewController(todo: todo)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if viewModel.currentPage * viewModel.itemsPerPage < viewModel.todosList.count {
                viewModel.currentPage += 1
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.isSearching = false
        } else {
            viewModel.isSearching = true
            viewModel.filteredTodos = viewModel.todosList.filter { todo in
                let matchesTitle = todo.title?.lowercased().contains(searchText.lowercased())
                let matchesUser = todo.user?.name?.lowercased().contains(searchText.lowercased()) ?? false
                return matchesTitle ?? false
            }
        }
        tableView.reloadData()
    }
}

extension MainView: MainViewModelDelegate {
    func didFinish() {
        tableView.reloadData()
    }
    
    func didFail(error: any Error) {
        print(error)
    }
}
