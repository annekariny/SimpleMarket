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
    func didTapAddButton(at index: Int)
    func getMarketProductViewModel(from index: Int) -> MarketProductViewModel?
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
    private let imageLoader: ImageLoaderProtocol

    init(
        coordinator: MarketCoordinatorProtocol,
        productAPIManager: ProductAPIManagerProtocol = ProductAPIManager(),
        cartManager: CartManagerProtocol = CartManager(),
        imageLoader: ImageLoaderProtocol = ImageLoader()
    ) {
        self.coordinator = coordinator
        self.productAPIManager = productAPIManager
        self.cartManager = cartManager
        self.imageLoader = imageLoader
        fetchProductsFromAPI()
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

    private func addProductToCart(_ product: Product?) {
        guard let product = product  else {
            return
        }
        cartManager.sumProductQuantity(product: product)
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

    func getMarketProductViewModel(from index: Int) -> MarketProductViewModel? {
        guard products.indices.contains(index) else {
            return nil
        }
        return MarketProductViewModel(with: products[index], imageLoader: imageLoader)
    }

    func didTapAddButton(at index: Int) {
        guard products.indices.contains(index) else {
            return
        }
        let product = products[index]
        addProductToCart(product)
        view?.generateSystemFeedback()
        view?.animateCartButton()
    }

    func openCart() {
        coordinator?.openCart()
    }

    func openOrders() {
        coordinator?.openOrders()
    }
}
