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
    private let presenter: MarketPresenterProtocol
    private let logger = Logger()

    init(presenter: MarketPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.info("MarketViewController deinitialized")
    }

    // MARK: Setup View Layout
    private enum LayouContants {
        static let cellInset: CGFloat = 30
        static let cellSize: CGFloat = 150
        static let cartButtonSize: CGFloat = 25
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: LayouContants.cellInset,
            left: LayouContants.cellInset,
            bottom: LayouContants.cellInset,
            right: LayouContants.cellInset
        )
        layout.itemSize = CGSize(width: LayouContants.cellSize, height: LayouContants.cellSize)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MarketCell.self)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var cartButton: UIBarButtonItem = {
        let buttonSize = CGRect(
            origin: .zero,
            size: CGSize(width: LayouContants.cartButtonSize, height: LayouContants.cartButtonSize)
        )
        let button = UIButton(frame: buttonSize)
        button.setBackgroundImage(Image.cart, for: .normal)
        button.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

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
        navigationItem.rightBarButtonItem = cartButton
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }

    @objc private func openOrders() {
        presenter.openOrders()
    }

    @objc private func openCart() {
        presenter.openCart()
    }

    private func animateCartButton() {
        navigationItem.rightBarButtonItem?.customView?.animateScalingUpDown()
    }

    private func generateSystemFeedback() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource
extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MarketCell
        cell.delegate = self
        cell.product = presenter.getProduct(from: indexPath.row)
        return cell
    }
}

// MARK: - MarketViewProtocol
extension MarketViewController: MarketViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - MarketCellDelegate
extension MarketViewController: MarketCellDelegate {
    func didTapAddProduct(_ product: Product?) {
        presenter.addProductToCart(product)
        generateSystemFeedback()
        animateCartButton()
    }
}
