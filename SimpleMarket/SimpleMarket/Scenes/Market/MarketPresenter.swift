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
    func addProductToCart(_ product: Product?)
    func openCart()
}

final class MarketPresenter {
    weak var view: MarketViewProtocol?
    private weak var coordinator: MarketCoordinatorProtocol?
    private let productAPIManager: ProductAPIManagerProtocol?
    private let cartManager = CartManager()
    private var products = [Product]()
    private var cart: Order?
    private let notificationManager: NotificationManagerProtocol

    init(
        coordinator: MarketCoordinatorProtocol,
        productAPIManager: ProductAPIManagerProtocol = ProductAPIManager(),
        notificationManager: NotificationManagerProtocol = NotificationManager()
    ) {
        self.coordinator = coordinator
        self.productAPIManager = productAPIManager
        self.notificationManager = notificationManager
        fetchProductsFromAPI()
        cartManager.deleteAll()
        getCart()
        addListeners()
    }

    deinit {
    }

    private func addListeners() {
        notificationManager.add(observer: self, selector: #selector(getCart), notification: LocalNotification.orderSaved, object: nil)
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

    @objc private func getCart() {
        cart = cartManager.orderInProgress()
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

    func addProductToCart(_ product: Product?) {
        guard let product = product, let order = cart else {
            return
        }
        cartManager.sumProductQuantity(product: product, order: order)
        getCart()
    }

    func openCart() {
        coordinator?.openCart()
    }
}
