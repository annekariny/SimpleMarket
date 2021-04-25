//
//  CartViewController.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    func reloadTableView()
    func updateTotalCart(total: String)
}

final class CartViewController: UIViewController {
    private let logger = Logger()
    private let presenter: CartPresenterProtocol

    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.info("CartViewController deinitialized")
    }

    // MARK: Setup Layout
    private enum LayoutConstants {
        static let orderButtonFontSize: CGFloat = 30
        static let orderButtonHeight: CGFloat = 100
        static let padding: CGFloat = 10
        static let rowHeight: CGFloat = 100
        static let totalValueFontSize: CGFloat = 24
        static let totalValueHeight: CGFloat = 40
    }

    private lazy var tableView: UITableView = {
        let tableView: UITableView
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartCell.self)
        return tableView
    }()

    private lazy var totalOrder: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LayoutConstants.totalValueFontSize, weight: .semibold)
        return label
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Order", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: LayoutConstants.orderButtonFontSize, weight: .bold)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(finishOrder), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateCart()
    }

    private func setupViewLayout() {
        title = presenter.title
        view.backgroundColor = .systemGroupedBackground
        setupNavigation()
        addSubviews()
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(orderButton)
        view.addSubview(totalOrder)

        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: totalOrder.topAnchor,
            trailing: view.trailingAnchor
        )
        totalOrder.anchor(
            leading: view.leadingAnchor,
            bottom: orderButton.topAnchor,
            trailing: view.trailingAnchor,
            paddingLeading: LayoutConstants.padding,
            height: LayoutConstants.totalValueHeight
        )
        orderButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            height: LayoutConstants.orderButtonHeight
        )
    }

    @objc private func didTapDone() {
        presenter.didTapDone()
    }

    @objc private func finishOrder() {
        presenter.finishOrder()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CartCell
        let orderItem = presenter.getOrderItem(for: indexPath.row)
        cell.delegate = self
        cell.index = indexPath.row
        cell.orderItem = orderItem
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        LayoutConstants.rowHeight
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }

    func updateTotalCart(total: String) {
        totalOrder.text = total
    }
}

// MARK: - CartCellDelegate
extension CartViewController: CartCellDelegate {
    func didTapAdd(_ orderItem: OrderItem?, at index: Int) {
        presenter.sumOrderItemQuantity(orderItem, at: index)
    }

    func didTapRemove(_ orderItem: OrderItem?, at index: Int) {
        presenter.reduceOrderItemQuantity(orderItem, at: index)
    }
}
