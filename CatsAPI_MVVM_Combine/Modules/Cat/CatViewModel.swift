//
//  CatViewModel.swift
//  CatsAPI_MVVM_RxSwift
//
//  Created by Roman Gorshkov on 23.12.2021.
//

import Foundation
import Combine

class CatViewModel {
    @Published var cats: Response = []
    private var cancellables = Set<AnyCancellable>()
    private let catsNetworkService: NetworkServiceProtocol
    private var page = GlobalConstants.initialPage
    private var isLoading = false
    
    var catsCount: Int {
        cats.count
    }
    
    func cat(at index: Int) -> Breed {
        cats[index]
    }
    
    init(catsNetworkService: NetworkServiceProtocol) {
        self.catsNetworkService = catsNetworkService
    }
}

extension CatViewModel {
    func fetchBreeds() {
        guard !isLoading else { return }
        
        isLoading = true
        
        catsNetworkService.fetchBreeds(with: page).sink { [weak self] (completion) in
            self?.isLoading = false
            if case .failure(let error) = completion {
                print(error)
            }
        } receiveValue: { [weak self ] breeds in
            self?.cats.append(contentsOf: breeds)
            self?.page += 1
        }
        .store(in: &cancellables)
    }
    
    func viewModelForSelectedRow(at indexPath: IndexPath) -> CatDetailViewModelProtocol {
        CatDetailViewModel(cat: cat(at: indexPath.row))
    }
}
