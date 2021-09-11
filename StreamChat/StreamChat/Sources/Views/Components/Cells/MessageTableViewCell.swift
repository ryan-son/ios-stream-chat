//
//  MessageTableViewCell.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {

    // MARK: Namespaces

    private enum Style {

        static let unknownUserInitial: Character = "U"

        enum UsernameInitialLabel {
            static let font: UIFont.TextStyle = .title2
            static let textColor: UIColor = .white
            static let cornerRadius: CGFloat = 15
            static let backgroundColor: UIColor = .systemGray2
        }

        enum ContentStackView {
            static let spacing: CGFloat = 3
        }

        enum UsernameLabel {
            static let font: UIFont.TextStyle = .footnote
            static let textColor: UIColor = .systemGray
        }

        enum MessageLabel {
            static let topBottomInset: CGFloat = 8
            static let leftRightInset: CGFloat = 15
            static let font: UIFont.TextStyle = .body
            static let textColorForMe: UIColor = .white
            static let textColorForSomeoneElse: UIColor = .label
            static let backgroundColorForMe: UIColor = .systemGreen
            static let backgroundColorForSomeoneElse: UIColor = .systemGray5
            static let cornerRadius: CGFloat = 12
        }

        enum DateTimeLabel {
            static let font: UIFont.TextStyle = .caption2
            static let textColor: UIColor = .systemGray2
        }

        enum Constraint {
            static let usernameInitialLabelLeading: CGFloat = 8
            static let usernameInitialLabelTop: CGFloat = 8
            static let usernameInitialLabelWidth: CGFloat = 40
            static let usernameInitialLabelHeight: CGFloat = 40

            static let contentStackViewLeading: CGFloat = 8
            static let contentStackViewTop: CGFloat = 4
            static let contentStackViewTrailing: CGFloat = -8
            static let contentStackViewBottom: CGFloat = -4
        }
    }
    // MARK: Properties

    static let reuseIdentifier = "MessageTableViewCell"

    // MARK: Views

    private let usernameInitialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.UsernameInitialLabel.font)
        label.layer.cornerRadius = Style.UsernameInitialLabel.cornerRadius
        label.backgroundColor = Style.UsernameInitialLabel.backgroundColor
        label.textColor = Style.UsernameInitialLabel.textColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.ContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.UsernameLabel.font)
        label.textColor = Style.UsernameLabel.textColor
        return label
    }()

    private let messageLabel: UILabel = {
        let label = InsetLabel(top: Style.MessageLabel.topBottomInset,
                               left: Style.MessageLabel.leftRightInset,
                               bottom: Style.MessageLabel.topBottomInset,
                               right: Style.MessageLabel.leftRightInset)
        label.numberOfLines = .zero
        label.font = UIFont.preferredFont(forTextStyle: Style.MessageLabel.font)
        label.layer.cornerRadius = Style.MessageLabel.cornerRadius
        label.clipsToBounds = true
        return label
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: Style.DateTimeLabel.font)
        label.textColor = Style.DateTimeLabel.textColor
        return label
    }()

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MessageTableViewCell.reuseIdentifier)
        setUpSubviews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Set up views

    private func setUpSubviews() {
        contentStackView.addArrangedSubview(usernameLabel)
        contentStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(dateTimeLabel)

        contentView.addSubview(usernameInitialLabel)
        contentView.addSubview(contentStackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            usernameInitialLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: Style.Constraint.usernameInitialLabelLeading),
            usernameInitialLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: Style.Constraint.usernameInitialLabelTop),
            usernameInitialLabel.widthAnchor.constraint(equalToConstant: Style.Constraint.usernameInitialLabelWidth),
            usernameInitialLabel.heightAnchor.constraint(equalToConstant: Style.Constraint.usernameInitialLabelHeight)
        ])

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: usernameInitialLabel.trailingAnchor,
                                                      constant: Style.Constraint.contentStackViewLeading),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: Style.Constraint.contentStackViewTop),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: Style.Constraint.contentStackViewTrailing),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: Style.Constraint.contentStackViewBottom)
        ])
    }

    // MARK: Configure a cell while dequeuing

    func configure(with message: Message) {
        usernameInitialLabel.text = String(message.sender.name.first ?? Style.unknownUserInitial)
        usernameLabel.text = message.sender.name
        messageLabel.text = message.text
        dateTimeLabel.text = message.dateTime.formatted

        setStyleByUser(with: message)
        setNeedsLayout()
    }

    private func setStyleByUser(with message: Message) {
        if message.sender.senderType == .me {
            usernameInitialLabel.isHidden = true
            usernameLabel.isHidden = true
            contentStackView.alignment = .trailing
            messageLabel.textColor = Style.MessageLabel.textColorForMe
            messageLabel.backgroundColor = Style.MessageLabel.backgroundColorForMe
        } else {
            usernameInitialLabel.isHidden = false
            usernameLabel.isHidden = false
            contentStackView.alignment = .leading
            messageLabel.textColor = Style.MessageLabel.textColorForSomeoneElse
            messageLabel.backgroundColor = Style.MessageLabel.backgroundColorForSomeoneElse
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameInitialLabel.text = nil
        usernameLabel.text = nil
        messageLabel.text = nil
        dateTimeLabel.text = nil
        messageLabel.textColor = nil
        messageLabel.backgroundColor = nil
    }
}
