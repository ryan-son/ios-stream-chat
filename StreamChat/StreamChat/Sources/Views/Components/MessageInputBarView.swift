//
//  MessageInputBarView.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import UIKit

final class MessageInputBarView: UIView {

    // MARK: Namespaces

    private enum Style {

        static let backgroundColor: UIColor = .systemGray5

        enum ContentStackView {
            static let spacing: CGFloat = 8
        }

        enum InputTextView {
            static let font: UIFont.TextStyle = .title3
            static let cornerRadius: CGFloat = 10
        }

        enum SendButton {
            static let frameSize = CGSize(width: 20, height: 20)
            private static let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20,
                                                                                 weight: .light,
                                                                                 scale: .large)
            static let image = UIImage(
                systemName: "paperplane.fill",
                withConfiguration: Style.SendButton.symbolConfiguration
            )?.withTintColor(.white, renderingMode: .alwaysOriginal)
            static let contentEdgeInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
            static let backgroundColor: UIColor = .systemGreen
        }

        enum Constraint {
            static let leading: CGFloat = 15
            static let trailing: CGFloat = -15
            static let top: CGFloat = 8
        }
    }

    // MARK: Properties

    weak var delegate: MessageInputBarViewDelegate?

    // MARK: Views

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Style.ContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: Style.InputTextView.font)
        textView.layer.cornerRadius = Style.InputTextView.cornerRadius
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        return textView
    }()

    let sendButton: UIButton = {
        let button = UIButton()
        button.frame.size = Style.SendButton.frameSize
        button.setImage(Style.SendButton.image, for: .normal)
        button.contentEdgeInsets = Style.SendButton.contentEdgeInset
        button.backgroundColor = Style.SendButton.backgroundColor
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.isHidden = true
        return button
    }()

    // MARK: Initializers

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Style.backgroundColor
        setUpSubviews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Set up views

    private func setUpSubviews() {
        contentStackView.addArrangedSubview(inputTextView)
        contentStackView.addArrangedSubview(sendButton)
        addSubview(contentStackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                      constant: Style.Constraint.leading),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                       constant: Style.Constraint.trailing),
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                  constant: Style.Constraint.top)
        ])
    }

    // MARK: Button actions

    @objc private func sendButtonTapped() {
        guard let delegate = delegate,
              let message = inputTextView.text,
              !message.isEmpty else { return }
        delegate.didTapSendButton(message: message)
        inputTextView.text = ""
    }
}
