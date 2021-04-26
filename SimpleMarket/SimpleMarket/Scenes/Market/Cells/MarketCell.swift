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
    private enum LayoutConstants {
        static let titleFontSize: CGFloat = 14
        static let valueFontSize: CGFloat = 16
        static let buttonSize: CGFloat = 30
        static let textHeight: CGFloat = 30
        static let padding: CGFloat = 8
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.circledPlus(size: LayoutConstants.buttonSize), for: .normal)
        button.addTarget(self, action: #selector(didTapAddProduct), for: .touchUpInside)
        return button
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LayoutConstants.titleFontSize)
        return label
    }()

    private lazy var value: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LayoutConstants.valueFontSize, weight: .semibold)
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
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.isUserInteractionEnabled = false
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedLayout()
    }

    private func setupLayout() {
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(addButton)
        addSubview(title)
        addSubview(value)

        addButton.anchor(
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingBottom: LayoutConstants.padding,
            paddingTrailing: LayoutConstants.padding,
            width: LayoutConstants.buttonSize,
            height: LayoutConstants.buttonSize
        )
        title.anchor(
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: addButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        value.anchor(
            leading: leadingAnchor,
            bottom: title.topAnchor,
            trailing: addButton.leadingAnchor,
            paddingLeading: LayoutConstants.padding,
            height: LayoutConstants.textHeight
        )
        imageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: value.topAnchor,
            trailing: trailingAnchor
        )
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
