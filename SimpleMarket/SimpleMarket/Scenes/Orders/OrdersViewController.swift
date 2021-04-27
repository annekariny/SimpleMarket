//
//  OrdersViewController.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import UIKit

protocol OrdersViewProtocol: AnyObject {
    func reloadTableView()
}

final class OrdersViewController: UIViewController {
    private let logger = Logger()
    private let presenter: OrdersPresenterProtocol

    init(presenter: OrdersPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.info("OrdersViewController deinitialized")
    }

    // MARK: Setup Layout
    private lazy var tableView: UITableView = {
        let tableView: UITableView
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OrderCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchOrders()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteAll))
    }

    private func addSubviews() {
        view.addSubview(tableView)
        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }

    @objc private func didTapDone() {
        presenter.didTapDone()
    }

    @objc private func didTapDeleteAll() {
        presenter.didTapDeleteAll()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OrderCell
        cell.order = presenter.getOrder(at: indexPath.row)
        return cell
    }
}

// MARK: - CartViewProtocol
extension OrdersViewController: OrdersViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}
