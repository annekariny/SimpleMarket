//
//  MarketViewController.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol MarketViewProtocol: AnyObject {
    func reloadCollectionView()
}

final class MarketViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        layout.itemSize = CGSize(width: 150, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MarketCell.self)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let presenter: HomePresenterProtocol

    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        setupNavigationBar()
        setupCollectionView()
    }

    private func setupViewLayout() {
        title = presenter.title
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.bulletList, style: .plain, target: self, action: #selector(openOrders))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Image.cart, style: .plain, target: self, action: #selector(openCart))
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }

    @objc private func openOrders() {
    }

    @objc private func openCart() {
    }
}

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarketCell
        cell.product = presenter.getProduct(from: indexPath.row)
        return cell
    }
}

extension MarketViewController: MarketViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
