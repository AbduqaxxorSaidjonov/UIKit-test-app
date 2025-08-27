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

class MainViewModel: ObservableObject {
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
    private(set) var todosList: [TodosModel] = []
    var filteredTodos: [TodosModel] = []
    var currentPage = 1
    let itemsPerPage = 20
    var isSearching = false
    
    // MARK: - Pagination
    
    func getCurrentPageTodos() -> [TodosModel] {
        let endIndex = min(currentPage * itemsPerPage, todosList.count)
        return Array(todosList.prefix(endIndex))
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
                    self.delegate?.didFinish()
                }
            }
            .store(in: &anyCancellable)
    }
}
