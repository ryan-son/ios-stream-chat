//
//  LoginViewController.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import UIKit

final class JoinChatRoomViewController: UIViewController {

    // MARK: Namespaces

    private enum Style {

        enum NavigationBar {
            static let title: String = "Sign in"
        }

        enum ContentStackView {
            static let spacingAtPortraitOrientation: CGFloat = 80
            static let spacingAtLandscapeOrientation: CGFloat = 30
        }

        enum WelcomeLabel {
            static let welcomeLabelText: String = "Welcome!"
            static let font: UIFont.TextStyle = .largeTitle
        }

        enum UsernameTextField {
            static let placeholderText: String = "Please enter your name..."
            static let borderWidth: CGFloat = 1
            static let font: UIFont.TextStyle = .title3
            static let backgroundColor: UIColor = .systemGray6
        }

        enum JoinButton {
            static let title: String = "Join!"
            static let font: UIFont.TextStyle = .headline
            static let backgroundColor: UIColor = .systemGreen
            static let contentEdgeInsets = UIEdgeInsets(top: 7, left: 30, bottom: 7, right: 30)
            static let cornerRadius: CGFloat = 10
        }

        enum Constraint {
            static let centerYAgainstViewSafeArea: CGFloat = -100
        }

        enum Alert {
            static let UsernameRequiredTitle: String = "이름을 입력해주세요"
            static let okActionTitle: String = "확인"
        }
    }

    // MARK: Properties

    private var centerYConstraint: NSLayoutConstraint?

    // MARK: Views

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = UITraitCollection.current.horizontalSizeClass == .compact
            ? Style.ContentStackView.spacingAtPortraitOrientation
            : Style.ContentStackView.spacingAtLandscapeOrientation
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = Style.WelcomeLabel.welcomeLabelText
        label.font = UIFont.preferredFont(forTextStyle: Style.WelcomeLabel.font)
        label.textAlignment = .center
        return label
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Style.UsernameTextField.placeholderText
        textField.font = UIFont.preferredFont(forTextStyle: Style.UsernameTextField.font)
        textField.backgroundColor = Style.UsernameTextField.backgroundColor
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()

    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle(Style.JoinButton.title, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: Style.JoinButton.font)
        button.backgroundColor = Style.JoinButton.backgroundColor
        button.contentEdgeInsets = Style.JoinButton.contentEdgeInsets
        button.layer.cornerRadius = Style.JoinButton.cornerRadius
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setAttributes()
        setUpNavigationBar()
        setUpSubviews()
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificationObservers()
        removeKeyboardDismissGestureRecognizer()
    }

    // MARK: Set up views

    private func setDelegates() {
        usernameTextField.delegate = self
    }

    private func setAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setUpNavigationBar() {
        title = Style.NavigationBar.title
    }

    private func setUpSubviews() {
        contentStackView.addArrangedSubview(welcomeLabel)
        contentStackView.addArrangedSubview(usernameTextField)
        contentStackView.addArrangedSubview(joinButton)
        view.addSubview(contentStackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
        centerYConstraint = contentStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        centerYConstraint?.isActive = true
    }

    // MARK: Handling keyboard notifications

    private func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        centerYConstraint?.constant = -keyboardFrame.height / 2

        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        centerYConstraint?.constant = .zero
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Dismiss keyboard by tapping

    private func addKeyboardDismissGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func removeKeyboardDismissGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.removeGestureRecognizer(tap)
    }

    // MARK: Change layout the size classes

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass == .compact {
            contentStackView.spacing = Style.ContentStackView.spacingAtPortraitOrientation
        } else {
            contentStackView.spacing = Style.ContentStackView.spacingAtLandscapeOrientation
        }
    }

    // MARK: Join chat room

    @objc private func joinButtonTapped() {
        let chatRoomSocket = ChatRoomSocket()
        let chatRoomViewModel = ChatRoomViewModel(chatRoomSocket: chatRoomSocket)
        let chatRoomViewController = ChatRoomViewController()
        chatRoomViewController.chatRoomViewModel = chatRoomViewModel
        guard let username = usernameTextField.text,
              !username.isEmpty else {
            showUsernameRequiredAlert()
            return
        }
        chatRoomViewController.join(with: username)
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }

    // MARK: Alerts

    private func showUsernameRequiredAlert() {
        let usernameRequiredAlert = UIAlertController(title: Style.Alert.UsernameRequiredTitle,
                                                      message: nil,
                                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Style.Alert.okActionTitle, style: .default) { [self] _ in
            usernameTextField.becomeFirstResponder()
        }
        usernameRequiredAlert.addAction(okAction)
        present(usernameRequiredAlert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension JoinChatRoomViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let chatRoomViewController = ChatRoomViewController()
        guard let username = textField.text,
              !username.isEmpty else {
            showUsernameRequiredAlert()
            return false
        }
        chatRoomViewController.join(with: username)
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        return true
    }
}
