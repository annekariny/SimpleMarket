//
//  MarketCell.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol MarketCellDelegate: AnyObject {
    func didTapAddProduct(_ product: Product?)
}

final class MarketCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
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

    private lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var value: UILabel = {
        let label = UILabel()
        return label
    }()

    var product: Product? {
        didSet {
            title.text = product?.description
            value.text = product?.price.toCurrencyFormat()
            setImage()
        }
    }

    weak var delegate: MarketCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(imageView)
        addSubview(addButton)
        addSubview(title)
        addSubview(value)

        addButton.anchor(bottom: bottomAnchor, trailing: trailingAnchor, width: 50, height: 50)
        title.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: addButton.leadingAnchor, height: 30)
        value.anchor(leading: leadingAnchor, bottom: title.topAnchor, trailing: addButton.leadingAnchor, height: 30)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: value.topAnchor, trailing: trailingAnchor)
    }

    @objc private func didTapAddProduct() {
        delegate?.didTapAddProduct(product)
    }

    private func setImage() {
        if let image = product?.image {
            imageView.image = image
        } else {
            guard let imageURL = product?.imageURL else {
                return
            }
            URLHelper().downloadImage(withURL: imageURL) { [weak self] image in
                self?.product?.image = image
                self?.imageView.image = image
            }
        }
    }
}
