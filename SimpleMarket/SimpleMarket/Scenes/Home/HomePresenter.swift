//
//  HomePresenter.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

protocol HomePresenterProtocol {
    var title: String { get }
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    private var coordinator: HomeCoordinatorProtocol?
    //private let logger = Logger()


    init(
        coordinator: HomeCoordinatorProtocol
    ) {
        //self.store = store
        self.coordinator = coordinator
    }

    deinit {
        
    }
}

extension HomePresenter: HomePresenterProtocol {
    var title: String {
        "Daily Expenses"
    }
}
