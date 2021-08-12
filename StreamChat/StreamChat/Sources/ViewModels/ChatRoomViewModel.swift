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

    private let chatRoom = ChatRoom()
    private(set) var messages: [Message] = [] {
        didSet { changed?() }
    }

    // MARK: Initializers

    init() {
        chatRoom.delegate = self
    }

    // MARK: Chat room view model features

    func bind(with changed: @escaping (() -> Void)) {
        self.changed = changed
    }

    func message(at index: Int) -> Message? {
        guard index < messages.count else {
            Log.logic.notice(
                "\(StreamChatError.indexOutOfBound(requestedIndex: index, maxIndex: self.messages.count))"
            )
            return nil
        }
        return messages[index]
    }

    func send(message: String) {
        chatRoom.send(message: message)
    }

    func joinChat(with username: String) {
        chatRoom.connect()
        chatRoom.join(with: username)
    }

    func leaveChat() {
        chatRoom.leave()
        chatRoom.disconnect()
    }
}

// MARK: - ChatRoomDelegate

extension ChatRoomViewModel: ChatRoomDelegate {

    func didReceiveMessage(_ message: Message) {
        messages.append(message)
    }
}
