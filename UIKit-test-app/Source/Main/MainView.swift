//
//  ViewController.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 26/08/25.
//

import UIKit

class MainView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
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
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching
            ? viewModel.filteredTodos.count
            : viewModel.displayedTodos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let todo = viewModel.isSearching
            ? viewModel.filteredTodos[indexPath.row]
            : viewModel.displayedTodos[indexPath.row]
        cell.configure(with: todo)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 4 {
            viewModel.loadMore {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = viewModel.isSearching
            ? viewModel.filteredTodos[indexPath.row]
            : viewModel.displayedTodos[indexPath.row]
        let detailsVC = TodoDetailsViewController(todo: todo)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text ?? "Search todos or Users")
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText.isEmpty {
            viewModel.isSearching = false
        } else {
            viewModel.isSearching = true
            viewModel.filteredTodos = viewModel.todosList.filter { todo in
                let matchesTitle = todo.title?.lowercased().contains(searchText.lowercased()) ?? false
                let matchesUser = todo.user?.name?.lowercased().contains(searchText.lowercased()) ?? false
                return matchesTitle || matchesUser
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
