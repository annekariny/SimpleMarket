//
//  CartCell.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

final class CartCell: UITableViewCell {
    private enum LayoutConstants {
        static let titleFontSize: CGFloat = 16
        static let imageSize: CGFloat = 50
        static let buttonSize: CGFloat = 30
        static let textHeight: CGFloat = 20
        static let padding: CGFloat = 20
        static let textPadding: CGFloat = 16
        static let buttonPadding: CGFloat = 8
    }

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.circledPlus(size: 50), for: .normal)
        button.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
        return button
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.circledMinus(size: LayoutConstants.buttonSize), for: .normal)
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

    var didTapAddButton: (() -> Void)?
    var didTapRemoveButton: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cartProductViewModel: CartProductViewModel) {
        title.text = cartProductViewModel.productName
        unitValue.text = cartProductViewModel.price
        totalValue.text = cartProductViewModel.totalValue
        quantity.text = cartProductViewModel.quantity
        cartProductViewModel.loadImage { [weak self] image in
            self?.itemImageView.image = image
        }
    }

    private func addSubviews() {
        addSubview(itemImageView)
        addSubview(addButton)
        addSubview(removeButton)
        addSubview(title)
        addSubview(unitValue)
        addSubview(totalValue)
        addSubview(quantity)
        setupProductViewsConstraint()
        setupOrderDetailViewsConstraint()
    }

    private func setupProductViewsConstraint() {
        itemImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            width: LayoutConstants.imageSize
        )
        title.anchor(
            top: topAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: trailingAnchor,
            paddingTop: LayoutConstants.padding,
            paddingLeading: LayoutConstants.padding,
            paddingBottom: LayoutConstants.textPadding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        unitValue.anchor(
            top: title.bottomAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: removeButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            paddingBottom: LayoutConstants.textPadding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        totalValue.anchor(
            top: unitValue.bottomAnchor,
            leading: itemImageView.trailingAnchor,
            trailing: addButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            paddingBottom: LayoutConstants.textPadding,
            paddingTrailing: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
    }

    private func setupOrderDetailViewsConstraint() {
        addButton.anchor(
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingLeading: LayoutConstants.buttonPadding,
            paddingBottom: LayoutConstants.buttonPadding,
            paddingTrailing: LayoutConstants.padding,
            width: LayoutConstants.buttonSize,
            height: LayoutConstants.buttonSize
        )
        quantity.anchor(
            trailing: addButton.leadingAnchor,
            paddingLeading: LayoutConstants.buttonPadding,
            paddingBottom: LayoutConstants.buttonPadding,
            width: LayoutConstants.textHeight,
            height: LayoutConstants.textHeight,
            centerVertical: addButton.centerYAnchor
        )
        removeButton.anchor(
            bottom: bottomAnchor,
            trailing: quantity.leadingAnchor,
            paddingLeading: LayoutConstants.buttonPadding,
            paddingBottom: LayoutConstants.buttonPadding,
            width: LayoutConstants.buttonSize,
            height: LayoutConstants.buttonSize
        )
    }

    @objc private func didTapAddProduct() {
        didTapAddButton?()
    }

    @objc private func didTapRemoveProduct() {
        didTapRemoveButton?()
    }
}
