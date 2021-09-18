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

        static let backgroundColor: UIColor = .systemGray6

        enum ContentStackView {
            static let spacing: CGFloat = 8
        }

        enum InputTextView {
            static let font: UIFont.TextStyle = .title3
            static let cornerRadius: CGFloat = 10
            static let minHeight: CGFloat = 44
            static let maxHeight: CGFloat = 100
        }

        enum InputTextCountLabel {
            static let font: UIFont.TextStyle = .caption2
            static let textColor: UIColor = .systemGray
            static let maxCount: Int = 300
        }

        enum SendButton {
            static let frameSize = CGRect(x: .zero, y: .zero, width: 20, height: 20)
            private static let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 17,
                                                                                 weight: .heavy,
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
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var isOversized = false {
        didSet {
            guard oldValue != isOversized else { return }
            adjustInputTextViewConstraint()
        }
    }

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
        textView.adjustsFontForContentSizeCategory = true
        textView.layer.cornerRadius = Style.InputTextView.cornerRadius
        textView.isScrollEnabled = false
        textView.textContainer.heightTracksTextView = true
        textView.autocorrectionType = .no
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let rightComponentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.isHidden = true
        return stackView
    }()

    private let inputTextCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.isHidden = true
        return label
    }()

    private let sendButton: UIButton = {
        let button = UIButton(frame: Style.SendButton.frameSize)
        button.setImage(Style.SendButton.image, for: .normal)
        button.contentEdgeInsets = Style.SendButton.contentEdgeInset
        button.backgroundColor = Style.SendButton.backgroundColor
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    // MARK: Initializers

    init() {
        super.init(frame: .zero)
        inputTextView.delegate = self
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
        rightComponentStackView.addArrangedSubview(inputTextCountLabel)
        rightComponentStackView.addArrangedSubview(sendButton)
        contentStackView.addArrangedSubview(inputTextView)
        contentStackView.addArrangedSubview(rightComponentStackView)
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
        textViewHeightConstraint = inputTextView.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Style.InputTextView.minHeight
        )
        textViewHeightConstraint?.constant = Style.InputTextView.maxHeight
    }

    private func adjustInputTextViewConstraint() {
        inputTextView.isScrollEnabled = isOversized
        textViewHeightConstraint?.isActive = isOversized
        inputTextView.setNeedsUpdateConstraints()
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

extension MessageInputBarView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        isOversized = textView.contentSize.height > Style.InputTextView.maxHeight
        inputTextCountLabel.text = "\(String(textView.text.count))/\(Style.InputTextCountLabel.maxCount)"
        let numberOfLines: CGFloat
        numberOfLines = textView.intrinsicContentSize.height > 0
            ? textView.intrinsicContentSize.height / textView.font!.lineHeight
            : textView.contentSize.height
        inputTextCountLabel.isHidden = numberOfLines < 2
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isExceededMaxLength: Bool = textView.text.count + (text.count - range.length) > Style.InputTextCountLabel.maxCount
        if isExceededMaxLength {
            delegate?.showMaxBodyLengthExceededAlert()
        }
        return !isExceededMaxLength
    }
}
