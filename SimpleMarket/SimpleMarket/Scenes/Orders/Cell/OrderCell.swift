//
//  OrderCell.swift
//  SimpleMarket
//
//  Created by Kariny on 26/04/21.
//

import UIKit

final class OrderCell: UITableViewCell {
    private enum LayoutConstants {
        static let titleFontSize: CGFloat = 16
        static let padding: CGFloat = 20
    }

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LayoutConstants.titleFontSize, weight: .bold)
        return label
    }()

    private lazy var totalValue: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        return label
    }()

    var order: Order? {
        didSet {
            title.text = "\(Strings.order) #\(order?.id ?? 0)"
            let total = order?.total ?? 0
            totalValue.text = "\(Strings.total): \(total.toCurrencyFormat())"
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
        addSubview(title)
        addSubview(totalValue)

        title.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            paddingTop: LayoutConstants.padding / 2,
            paddingLeading: LayoutConstants.padding,
            paddingTrailing: LayoutConstants.padding
        )
        totalValue.anchor(
            top: title.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            paddingTop: LayoutConstants.padding / 2,
            paddingLeading: LayoutConstants.padding,
            paddingBottom: LayoutConstants.padding / 2,
            paddingTrailing: LayoutConstants.padding
        )
    }
}
