//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatRoomViewController: UIViewController {

    // MARK: Namespaces

    private enum Style {

        enum NavigationBar {
            static let title: String = "Let's chat!"
        }

        enum MessagesTableView {
            static let topContentInset: CGFloat = 10
        }

        enum Constraint {
            static let contentStackViewBottomWhenKeyboardShown: CGFloat = 27
        }

        enum Alert {
            static let maxLengthExceededTitle: String = "최대 글자수 초과"
            static let maxLengthExceededMessage: String = "300 자를 초과할 수 없어요."
            static let timeToDismissMaxLengthExceededAlert: TimeInterval = 0.3
            static let forbiddenStringContainedTitle: String = "제한된 문자 포함"
            static let forbiddenStringContainedMessage: String = "입력할 수 없는 문자열이 포함되어 있습니다."
            static let okActionTitle: String = "확인"
        }
    }

    // MARK: Properties

    var chatRoomViewModel: ChatRoomViewModel?
    private var bottomConstraint: NSLayoutConstraint?
    private var lastIndexPath: IndexPath? {
        guard let chatRoomViewModel = chatRoomViewModel else { return nil }
        return IndexPath(row: chatRoomViewModel.messages.count - 1, section: .zero)
    }

    // MARK: Views

    private let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.register(SystemMessageTableViewCell.self,
                           forCellReuseIdentifier: SystemMessageTableViewCell.reuseIdentifier)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let messagesInputBarView = MessageInputBarView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setUpNavigationBar()
        setUpSubviews()
        setUpConstraints()
        bindWithViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesTableView.contentInset.top = Style.MessagesTableView.topContentInset
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotificationObservers()
    }

    // MARK: Set delegates

    private func setDelegates() {
        messagesTableView.dataSource = self
        messagesInputBarView.delegate = self
    }

    // MARK: set up views

    private func setUpNavigationBar() {
        title = Style.NavigationBar.title
    }

    private func setUpSubviews() {
        view.addSubview(messagesTableView)
        view.addSubview(messagesInputBarView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            messagesInputBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesInputBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesInputBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        bottomConstraint = messagesInputBarView.contentStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
        bottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: messagesInputBarView.topAnchor)
        ])
    }

    // MARK: Chat room features

    func join(with username: String) {
        chatRoomViewModel?.joinChat(with: username)
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
        bottomConstraint?.constant = -keyboardFrame.height + Style.Constraint.contentStackViewBottomWhenKeyboardShown

        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.messagesInputBarView.rightComponentStackView.isHidden = false
            self.view.layoutIfNeeded()
            self.scrollToLastMessage()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        messagesTableView.contentInset = contentInset
        messagesTableView.scrollIndicatorInsets = contentInset
        bottomConstraint?.constant = .zero

        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.messagesInputBarView.rightComponentStackView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }

    private func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Positioning table view

    private func scrollToLastMessage() {
        guard let hasMessage = chatRoomViewModel?.messages.isEmpty,
              let lastIndexPath = lastIndexPath,
              !hasMessage else { return }
        messagesTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
    }

    // MARK: Dismiss keyboard by tapping

    func addKeyboardDismissGestureRecognizer() {
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

    // MARK: Data binding

    private func bindWithViewModel() {
        chatRoomViewModel?.bind { [weak self] in
            guard let self = self,
                  let lastIndexPath = self.lastIndexPath else { return }
            self.messagesTableView.insertRows(at: [lastIndexPath], with: .none)
            self.scrollToLastMessage()
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chatRoomViewModel = chatRoomViewModel else { return .zero }
        return chatRoomViewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = chatRoomViewModel?.message(at: indexPath.row) else {
            Log.ui.error("\(StreamChatError.messageNotFound.localizedDescription)")
            return MessageTableViewCell()
        }

        switch message.sender.senderType {
        case .system:
            guard let systemMessageCell = tableView.dequeueReusableCell(
                    withIdentifier: SystemMessageTableViewCell.reuseIdentifier,
                    for: indexPath) as? SystemMessageTableViewCell else {
                Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: SystemMessageTableViewCell.description()).localizedDescription)")
                return SystemMessageTableViewCell()
            }

            systemMessageCell.configure(with: message)
            return systemMessageCell
        default:
            guard let messageCell = tableView.dequeueReusableCell(
                    withIdentifier: MessageTableViewCell.reuseIdentifier,
                    for: indexPath) as? MessageTableViewCell else {
                Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: MessageTableViewCell.description()).localizedDescription)")
                return MessageTableViewCell()
            }

            messageCell.configure(with: message)
            return messageCell
        }
    }
}

// MARK: - MessageInputBarViewDelegate

extension ChatRoomViewController: MessageInputBarViewDelegate {

    func didTapSendButton(message: String) {
        chatRoomViewModel?.send(message: message)
    }

    func showMaxLengthExceededAlert() {
        let alert = UIAlertController(title: Style.Alert.maxLengthExceededTitle,
                                      message: Style.Alert.maxLengthExceededMessage,
                                      preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Style.Alert.timeToDismissMaxLengthExceededAlert) {
            alert.dismiss(animated: true)
        }
    }

    func showForbiddenStringContainedAlert() {
        let forbiddenStringContainedAlert = UIAlertController(title: Style.Alert.forbiddenStringContainedTitle,
                                                              message: Style.Alert.forbiddenStringContainedMessage,
                                                              preferredStyle: .alert)
        let okAction = UIAlertAction(title: Style.Alert.okActionTitle, style: .default)
        forbiddenStringContainedAlert.addAction(okAction)
        present(forbiddenStringContainedAlert, animated: true)
    }
}
