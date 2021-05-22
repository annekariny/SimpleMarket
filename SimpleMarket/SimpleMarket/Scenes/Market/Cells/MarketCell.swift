//
//  MarketCell.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import UIKit

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
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
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

    var didTapAddButton: (() -> Void)?

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

    func configure(with marketProductViewModel: MarketProductViewModel) {
        title.text = marketProductViewModel.productName
        value.text = marketProductViewModel.price
        imageView.image = marketProductViewModel.image
    }

    @objc private func didTapAdd() {
        didTapAddButton?()
    }
}
