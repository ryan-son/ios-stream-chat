//
//  SystemMessageTableViewCell.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

import UIKit

final class SystemMessageTableViewCell: UITableViewCell {

    private enum Style {

        enum SystemMessageLabel {
            static let topBottomInset: CGFloat = 5
            static let leftRightInset: CGFloat = 15
            static let font: UIFont.TextStyle = .body
            static let textColor: UIColor = .systemGray
            static let backgroundColor: UIColor = .systemGray6
            static let cornerRadius: CGFloat = 15
        }

        enum Constraint {
            static let systemMessageLabelTop: CGFloat = 4
            static let systemMessageLabelBottom: CGFloat = -4
        }
    }

    // MARK: Properties

    static let reuseIdentifier = "SystemMessageTableViewCell"

    // MARK: Views

    private let systemMessageLabel: UILabel = {
        let label = InsetLabel(top: Style.SystemMessageLabel.topBottomInset,
                               left: Style.SystemMessageLabel.leftRightInset,
                               bottom: Style.SystemMessageLabel.topBottomInset,
                               right: Style.SystemMessageLabel.leftRightInset)
        label.font = UIFont.preferredFont(forTextStyle: Style.SystemMessageLabel.font)
        label.textColor = Style.SystemMessageLabel.textColor
        label.backgroundColor = Style.SystemMessageLabel.backgroundColor
        label.layer.cornerRadius = Style.SystemMessageLabel.cornerRadius
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Set up views

    private func setUpSubviews() {
        contentView.addSubview(systemMessageLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            systemMessageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            systemMessageLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Style.Constraint.systemMessageLabelTop),
            systemMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: Style.Constraint.systemMessageLabelBottom)
        ])
    }

    // MARK: Configure a cell while dequeuing

    func configure(with message: Message) {
        systemMessageLabel.text = message.text
    }
}
