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
            static let contentStackViewBottom: CGFloat = -10
            static let contentStackViewBottomWhenKeyboardShown: CGFloat = 27
        }
    }

    // MARK: Properties

    let chatRoomViewModel = ChatRoomViewModel()
    private var bottomConstraint: NSLayoutConstraint?

    private var lastIndexPath: IndexPath {
        IndexPath(row: chatRoomViewModel.messages.count - 1, section: .zero)
    }

    // MARK: Views

    let messagesTableView: UITableView = {
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

    let messagesInputBarView = MessageInputBarView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setUpNavigationBar()
        setUpSubviews()
        setUpConstraints()
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
        bindWithViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesTableView.contentInset.top = Style.MessagesTableView.topContentInset
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatRoomViewModel.leaveChat()
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
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: Style.Constraint.contentStackViewBottom
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
        chatRoomViewModel.joinChat(with: username)
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
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.scrollToLastMessage()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        messagesTableView.contentInset = contentInset
        messagesTableView.scrollIndicatorInsets = contentInset
        bottomConstraint?.constant = -Style.Constraint.contentStackViewBottom

        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    // MARK: Positioning table view

    private func scrollToLastMessage() {
        guard !chatRoomViewModel.messages.isEmpty else { return }
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

    // MARK: Data binding

    private func bindWithViewModel() {
        chatRoomViewModel.bind { [weak self] in
            guard let self = self else { return }
            self.messagesTableView.insertRows(at: [self.lastIndexPath], with: .none)
            self.scrollToLastMessage()
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomViewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = chatRoomViewModel.message(at: indexPath.row) else {
            Log.ui.error("\(StreamChatError.messageNotFound)")
            return MessageTableViewCell()
        }

        switch message.sender.senderType {
        case .system:
            guard let systemMessageCell = tableView.dequeueReusableCell(
                    withIdentifier: SystemMessageTableViewCell.reuseIdentifier,
                    for: indexPath) as? SystemMessageTableViewCell else {
                Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: SystemMessageTableViewCell.self))")
                return SystemMessageTableViewCell()
            }

            systemMessageCell.configure(with: message)
            return systemMessageCell
        default:
            guard let messageCell = tableView.dequeueReusableCell(
                    withIdentifier: MessageTableViewCell.reuseIdentifier,
                    for: indexPath) as? MessageTableViewCell else {
                Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: MessageTableViewCell.self))")
                return MessageTableViewCell()
            }

            messageCell.configure(with: message)
            return messageCell
        }
    }
}

// MARK: - MessageInputBarViewDelegate

extension ChatRoomViewController: MessageInputBarViewDelegate {

    func sendButtonTapped(message: String) {
        chatRoomViewModel.send(message: message)
    }
}
