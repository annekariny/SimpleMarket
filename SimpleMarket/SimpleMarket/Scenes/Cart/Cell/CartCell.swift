//
//  CartCell.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapAdd(_ orderItem: OrderItem?, at index: Int)
    func didTapRemove(_ orderItem: OrderItem?, at index: Int)
}

final class CartCell: UITableViewCell {
    private enum LayoutConstants {
        static let titleFontSize: CGFloat = 16
        static let defaultHeight: CGFloat = 50
        static let defaultWidth: CGFloat = 50
        static let textHeight: CGFloat = 20
        static let padding: CGFloat = 20
    }

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
        label.font = UIFont.systemFont(ofSize: LayoutConstants.titleFontSize, weight: .semibold)
        return label
    }()

    private lazy var unitValue: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()

    private lazy var totalValue: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        return label
    }()

    private lazy var quantity: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    var index = 0

    var orderItem: OrderItem? {
        didSet {
            title.text = orderItem?.product?.description
            unitValue.text = orderItem?.product?.price.toCurrencyFormat()
            totalValue.text = orderItem?.totalValue.toCurrencyFormat()
            quantity.text = orderItem?.quantity.description
            setImage()
        }
    }

    weak var delegate: CartCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(itemImageView)
        addSubview(addButton)
        addSubview(removeButton)
        addSubview(title)
        addSubview(unitValue)
        addSubview(totalValue)
        addSubview(quantity)

        itemImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            width: LayoutConstants.defaultWidth
        )
        title.anchor(
            top: topAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: trailingAnchor,
            paddingLeading: LayoutConstants.padding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.defaultHeight
        )
        unitValue.anchor(
            top: title.bottomAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: removeButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        totalValue.anchor(
            top: unitValue.bottomAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: addButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        addButton.anchor(
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            width: LayoutConstants.defaultWidth,
            height: LayoutConstants.defaultHeight
        )
        quantity.anchor(
            trailing: addButton.leadingAnchor,
            width: LayoutConstants.textHeight,
            height: LayoutConstants.textHeight,
            centerVertical: addButton.centerYAnchor
        )
        removeButton.anchor(
            bottom: bottomAnchor,
            trailing: quantity.leadingAnchor,
            width: LayoutConstants.defaultWidth,
            height: LayoutConstants.defaultHeight
        )
    }

    @objc private func didTapAddProduct() {
        delegate?.didTapAdd(orderItem, at: index)
    }

    @objc private func didTapRemoveProduct() {
        delegate?.didTapRemove(orderItem, at: index)
    }

    private func setImage() {
        if let image = orderItem?.product?.image {
            itemImageView.image = image
        } else {
            guard let imageURL = orderItem?.product?.imageURL else {
                return
            }
            URLHelper().downloadImage(withURL: imageURL) { [weak self] image in
                self?.orderItem?.product?.image = image
                self?.itemImageView.image = image
            }
        }
    }
}
