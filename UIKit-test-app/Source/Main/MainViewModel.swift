//
//  MainViewModel.swift
//  UIKit-test-app
//
//  Created by Abduqaxxor Saidjonov on 26/08/25.
//

import Foundation
import Combine

protocol MainViewModelDelegate: AnyObject {
    func didFinish()
    func didFail(error: Error)
}

class MainViewModel {
    var isLoading: Bool = false
    var showAlert: Bool = false
    var alertMessage: String? {
        didSet {
            showAlert = true
        }
    }
    
    var sessionService: BaseApiService = .init()
    var anyCancellable: Set<AnyCancellable> = []
    
    weak var delegate: MainViewModelDelegate?
    
    var filteredTodos: [TodosModel] = []
    var currentPage = 1
    let itemsPerPage = 20
    var isSearching = false
    
    private(set) var todosList: [TodosModel] = []
    private(set) var usersList: [User] = []
    private(set) var displayedTodos: [TodosModel] = []
    
    // MARK: - Pagination
    
    func resetPagination() {
        currentPage = 1
        displayedTodos = Array(todosList.prefix(itemsPerPage))
    }
    
    func loadMore(onSuccess: () -> Void) {
        guard displayedTodos.count < todosList.count else { return }
        currentPage += 1
        let endIndex = min(currentPage * itemsPerPage, todosList.count)
        displayedTodos = Array(todosList.prefix(endIndex))
        onSuccess()
    }
}

// MARK: - API CALLS
extension MainViewModel {
    func getTodos() {
        isLoading = true
        sessionService.getTodosList()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.alertMessage = "Network Error"
                    self.delegate?.didFail(error: error)
                default:
                    break
                }
            } receiveValue: { response in
                self.isLoading = false
                if let response = response {
                    self.todosList = response
                    self.getUsers()
                }
            }
            .store(in: &anyCancellable)
    }
    
    func getUsers() {
        isLoading = true
        sessionService.getUsersList()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.alertMessage = "Network Error"
                    self.delegate?.didFail(error: error)
                default:
                    break
                }
            } receiveValue: { response in
                self.isLoading = false
                if let response = response {
                    self.usersList = response
                    self.todosList.indices.forEach { index in
                        self.todosList[index].user = self.usersList.filter({ $0.id == self.todosList[index].userId }).first
                    }
                    self.resetPagination()
                    self.delegate?.didFinish()
                }
            }
            .store(in: &anyCancellable)
    }
}
