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
            static let font: UIFont.TextStyle = .callout
            static let cornerRadius: CGFloat = 10
            static let minHeight: CGFloat = 44
            static let maxHeight: CGFloat = 132
        }

        enum InputTextCountLabel {
            static let font: UIFont.TextStyle = .caption2
            static let textColor: UIColor = .systemGray
            static let minimumScaleFactor: CGFloat = 0.5
            static let maxCount: Int = 300
            static let numberOfLinesToShowLabel: CGFloat = 2
        }

        enum SendButton {
            static let frameSize = CGRect(x: .zero, y: .zero, width: 20, height: 20)
            private static let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15,
                                                                                 weight: .heavy,
                                                                                 scale: .large)
            static let image = UIImage(
                systemName: "paperplane.fill",
                withConfiguration: Style.SendButton.symbolConfiguration
            )?.withTintColor(.white, renderingMode: .alwaysOriginal)
            static let contentEdgeInset = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: 8)
            static let backgroundColor: UIColor = .systemGreen
            static let cornerRadius: CGFloat = 20
        }

        enum Constraint {
            static let leading: CGFloat = 15
            static let trailing: CGFloat = -15
            static let top: CGFloat = 8
            static let bottom: CGFloat = -8
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
        textView.autocorrectionType = .no
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
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
        label.font = UIFont.preferredFont(forTextStyle: Style.InputTextCountLabel.font)
        label.textColor = Style.InputTextCountLabel.textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Style.InputTextCountLabel.minimumScaleFactor
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
        button.layer.cornerRadius = Style.SendButton.cornerRadius
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
                                                  constant: Style.Constraint.top),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -Style.Constraint.top)
        ])
        textViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: Style.InputTextView.maxHeight)
    }

    private func adjustInputTextViewConstraint() {
        inputTextView.isScrollEnabled = isOversized
        textViewHeightConstraint?.isActive = isOversized
        inputTextView.setNeedsUpdateConstraints()
        inputTextView.layoutIfNeeded()
    }

    // MARK: Button actions

    @objc private func sendButtonTapped() {
        guard let delegate = delegate,
              let message = inputTextView.text,
              !message.isEmpty else { return }
        guard !message.contains(StreamData.Infix.receive) else {
            delegate.showForbiddenStringContainedAlert()
            return
        }
        delegate.didTapSendButton(message: message)
        inputTextView.text = ""
    }
}

extension MessageInputBarView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        isOversized = textView.contentSize.height > Style.InputTextView.maxHeight

        setInputTextCountLabel(to: textView.text.count)
        showInputTextCountLabel(with: textView, whenExceeds: Style.InputTextCountLabel.numberOfLinesToShowLabel)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isWithinMaxLength: Bool = textView.text.count + (text.count - range.length) <= Style.InputTextCountLabel.maxCount

        if !isWithinMaxLength {
            delegate?.showMaxLengthExceededAlert()
        }
        return isWithinMaxLength
    }

    private func setInputTextCountLabel(to count: Int) {
        inputTextCountLabel.text = "\(String(count))/\(Style.InputTextCountLabel.maxCount)"
    }

    private func showInputTextCountLabel(with textView: UITextView, whenExceeds numberOfLines: CGFloat) {
        guard let fontHeight = textView.font?.lineHeight else { return }
        let calculatedNumberOfLines: CGFloat
        calculatedNumberOfLines = textView.intrinsicContentSize.height > .zero
            ? textView.intrinsicContentSize.height / fontHeight
            : textView.contentSize.height / fontHeight
        inputTextCountLabel.isHidden = calculatedNumberOfLines < numberOfLines
    }
}
