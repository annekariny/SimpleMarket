//
//  HomeViewController.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func reloadCollectionView()
}

final class HomeViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCell.self)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.cart, style: .plain, target: self, action: #selector(openCart))
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

extension HomeViewController: HomeViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

