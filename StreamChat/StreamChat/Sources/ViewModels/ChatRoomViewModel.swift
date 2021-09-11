//
//  ChatRoomViewModel.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import Foundation

final class ChatRoomViewModel {

    // MARK: Data binding

    private var changed: (() -> Void)?

    // MARK: Properties

    private let chatRoomSocket: ChatRoomSocket
    private(set) var messages: [Message] = [] {
        didSet { changed?() }
    }

    // MARK: Initializers

    init(chatRoomSocket: ChatRoomSocket) {
        self.chatRoomSocket = chatRoomSocket
        self.chatRoomSocket.delegate = self
    }

    // MARK: Chat room view model features

    func bind(with changed: @escaping (() -> Void)) {
        self.changed = changed
    }

    func message(at index: Int) -> Message? {
        guard index < messages.count else {
            Log.logic.notice("\(StreamChatError.indexOutOfBound(requestedIndex: index, maxIndex: self.messages.count).localizedDescription)")
            return nil
        }
        return messages[index]
    }

    func send(message: String) {
        chatRoomSocket.send(message: message)
    }

    func joinChat(with username: String) {
        chatRoomSocket.join(with: username)
    }

    func leaveChat() {
        chatRoomSocket.leave()
    }
}

// MARK: - ChatRoomSocketDelegate

extension ChatRoomViewModel: ChatRoomSocketDelegate {

    func didReceiveMessage(_ message: Message) {
        messages.append(message)
    }
}
