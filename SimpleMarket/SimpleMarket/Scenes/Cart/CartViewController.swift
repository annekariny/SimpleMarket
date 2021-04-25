//
//  CartViewController.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol CartViewProtocol: AnyObject {
    func deleteRow(at index: Int)
    func reloadRow(at index: Int)
    func reloadTableView()
}

final class CartViewController: UIViewController {
    private let presenter: CartPresenterProtocol
    private let rowHeight = CGFloat(100)

    private lazy var tableView: UITableView = {
        let tableView: UITableView
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = rowHeight
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartCell.self)
        return tableView
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Order", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.backgroundColor = .systemGreen
        return button
    }()

    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(orderButton)
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: orderButton.topAnchor,
            trailing: view.trailingAnchor
        )

        orderButton.anchor(
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            height: 100
        )
    }

    @objc private func didTapDone() {
        presenter.didTapDone()
    }
}

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
        rowHeight
    }
}

extension CartViewController: CartViewProtocol {
    func deleteRow(at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func reloadRow(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

extension CartViewController: CartCellDelegate {
    func didTapAdd(_ orderItem: OrderItem?, at index: Int) {
        presenter.sumOrderItemQuantity(orderItem, at: index)
    }

    func didTapRemove(_ orderItem: OrderItem?, at index: Int) {
        presenter.decreaseOrderItemQuantity(orderItem, at: index)
    }
}
