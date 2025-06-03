//
//  CategoriesViewModel.swift
//  MoneyMind
//
//  Created by Павел on 03.06.2025.
//

import Combine
import UIKit

final class CategoriesViewModel {
    // MARK: - Published Property
    
    @Published var categories: [TransactionCategory] = []
    @Published var filteredCategories: [TransactionCategory] = []
    
    // MARK: - Property

    private let coordinator: CategoriesCoordinator?
    private let expencesService: ExpencesServiceProtocol
    private let imageService: ImageServiceProtocol
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(
        coordinator: CategoriesCoordinator?,
        expencesService: ExpencesServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.coordinator = coordinator
        self.expencesService = expencesService
        self.imageService = imageService
        fetchCategories()
    }
    
    // MARK: - Private Methods
    
    private func fetchCategories() {
        expencesService.fetchCategories()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error with fetching categories - \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] categories in
                self?.categories = categories
                self?.filteredCategories = categories
            }
            .store(in: &bag)
    }
    
    // MARK: - Public Methods
    
    func getImageByURL(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        imageService.downloadImage(by: url) { image in
            completion(image)
        }
    }
}
