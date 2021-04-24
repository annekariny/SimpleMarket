//
//  CartCell.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    // func didTapAddProduct()
}

final class CartCell: UITableViewCell {
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.circledPlus, for: .normal)
        button.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
        return button
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.circledMinus, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveProduct), for: .touchUpInside)
        return button
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var unitValue: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var totalValue: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var quantity: UILabel = {
        let label = UILabel()
        return label
    }()

    var product: Product? {
        didSet {
            title.text = product?.description
            unitValue.text = product?.price.toCurrencyFormat()
            setImage()
        }
    }

    weak var delegate: CartCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(itemImageView)
        addSubview(addButton)
        addSubview(title)
        addSubview(unitValue)
        addSubview(totalValue)
        addSubview(quantity)

        itemImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, width: 50)
        title.anchor(top: topAnchor, leading: itemImageView.leadingAnchor, trailing: addButton.leadingAnchor, paddingTrailing: 50, height: 30)
        unitValue.anchor(top: title.bottomAnchor, leading: itemImageView.leadingAnchor, trailing: addButton.leadingAnchor, paddingTrailing: 50, height: 30)
        totalValue.anchor(top: unitValue.bottomAnchor, leading: itemImageView.leadingAnchor, trailing: addButton.leadingAnchor, paddingTrailing: 50, height: 30)

        addButton.anchor(bottom: bottomAnchor, trailing: trailingAnchor, width: 50, height: 50)
        quantity.anchor(bottom: bottomAnchor, trailing: addButton.leadingAnchor, width: 30, height: 30)
        removeButton.anchor(bottom: bottomAnchor, trailing: quantity.leadingAnchor, width: 50, height: 50)
    }

    @objc private func didTapAddProduct() {
        // delegate?.didTapAddProduct()
    }

    @objc private func didTapRemoveProduct() {
        // delegate?.didTapAddProduct()
    }

    private func setImage() {
        if let image = product?.image {
            itemImageView.image = image
        } else {
            guard let imageURL = product?.imageURL else {
                return
            }
            URLHelper().downloadImage(withURL: imageURL) { [weak self] image in
                self?.product?.image = image
                self?.itemImageView.image = image
            }
        }
    }
}
