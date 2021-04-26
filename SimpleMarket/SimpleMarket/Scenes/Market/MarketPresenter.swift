//
//  MarketPresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol MarketPresenterProtocol {
    var title: String { get }
    var numberOfItemsInSection: Int { get }
    func getProduct(from index: Int) -> Product?
    func addProductToCart(_ product: Product?)
    func openCart()
    func openOrders()
}

final class MarketPresenter {
    private weak var coordinator: MarketCoordinatorProtocol?
    weak var view: MarketViewProtocol?

    private let productAPIManager: ProductAPIManagerProtocol
    private let cartManager: CartManagerProtocol
    private var products = [Product]()
    private let logger = Logger()

    init(
        coordinator: MarketCoordinatorProtocol,
        productAPIManager: ProductAPIManagerProtocol = ProductAPIManager(),
        cartManager: CartManagerProtocol = CartManager()
    ) {
        self.coordinator = coordinator
        self.productAPIManager = productAPIManager
        self.cartManager = cartManager
        fetchProductsFromAPI()
        // cartManager.deleteAll()
    }

    deinit {
        logger.info("MarketPresenter deinitialized")
    }

    private func fetchProductsFromAPI() {
        productAPIManager.getProducts { [weak self] (products, error) in
            guard error == nil else {
                return
            }
            self?.products = products
            self?.view?.reloadCollectionView()
        }
    }
}

// MARK: - MarketPresenterProtocol
extension MarketPresenter: MarketPresenterProtocol {
    var title: String {
        Strings.market
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

    func addProductToCart(_ product: Product?) {
        guard let product = product  else {
            return
        }
        cartManager.sumProductQuantity(product: product)
    }

    func openCart() {
        coordinator?.openCart()
    }

    func openOrders() {
        coordinator?.openOrders()
    }
}
