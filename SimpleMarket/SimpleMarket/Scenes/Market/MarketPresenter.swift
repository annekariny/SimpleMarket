//
//  MarketPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol HomePresenterProtocol {
    var title: String { get }
    var numberOfSections: Int { get }
    var numberOfItemsInSection: Int { get }
    func getProduct(from index: Int) -> Product?
    func openCart()
}

final class MarketPresenter {
    weak var view: MarketViewProtocol?
    private weak var coordinator: MarketCoordinatorProtocol?
    private let productAPIManager: ProductAPIManagerProtocol?
    private var products = [Product]()

    init(
        coordinator: MarketCoordinatorProtocol,
        productAPIManager: ProductAPIManagerProtocol = ProductAPIManager()
    ) {
        self.coordinator = coordinator
        self.productAPIManager = productAPIManager
        fetchProductsFromAPI()
    }

    deinit {
    }

    private func fetchProductsFromAPI() {
        productAPIManager?.getProducts { [weak self] (products, error) in
            guard error == nil else {
                return
            }
            self?.products = products
            self?.view?.reloadCollectionView()
        }
    }
}

extension MarketPresenter: HomePresenterProtocol {
    var title: String {
        "Market"
    }

    var numberOfSections: Int {
        1
    }

    var numberOfItemsInSection: Int {
        products.count
    }

    func getProduct(from index: Int) -> Product? {
        guard products.indices.contains(index) else {
            return nil
        }
        return products[index]
    }

    func openCart() {
        coordinator?.openCart()
    }
}
