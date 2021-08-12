//
//  ChatRoom.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/10.
//

import Foundation

final class ChatRoom: NSObject {

    // MARK: Namespaces

    private enum ConnectionSetting {

        // MARK: TCP Connection information

        static let host: String = NetworkConnection.host
        static let port: Int = NetworkConnection.port

        static let minReadLength: Int = 1
        static let maxReadLength: Int = 2400

        static let readTimeout: TimeInterval = .zero
        static let writeTimeout: TimeInterval = 3
    }

    private enum DefaultUser {

        static let system = User(name: "SYS", senderType: .system)
        static let unknown = User(name: "Unknown", senderType: .me)
    }

    // MARK: Properties

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private var streamTask: URLSessionStreamTask?
    private var user: User = DefaultUser.unknown
    weak var delegate: ChatRoomDelegate?

    // MARK: Chat room features

    func connect() {
        let streamTask = session.streamTask(withHostName: ConnectionSetting.host, port: ConnectionSetting.port)
        streamTask.resume()
        read(from: streamTask)
        self.streamTask = streamTask
    }

    func join(with username: String) {
        user = User(name: username, senderType: .me)
        guard let joiningStreamData: Data = username.asJoiningStreamData else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToData(location: #function))")
            return
        }
        write(joiningStreamData)
    }

    func send(message: String) {
        guard let sendingStreamData: Data = message.asSendingStreamData else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToData(location: #function))")
            return
        }
        write(sendingStreamData)
    }

    func leave() {
        guard let leavingStreamData: Data = String.leavingStreamData else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToData(location: #function))")
            return
        }
        write(leavingStreamData)
    }

    func disconnect() {
        session.finishTasksAndInvalidate()
    }

    // MARK: Private Methods

    private func read(from stream: URLSessionStreamTask) {
        stream.readData(ofMinLength: ConnectionSetting.minReadLength,
                        maxLength: ConnectionSetting.maxReadLength,
                        timeout: ConnectionSetting.readTimeout) { [weak self] data, _, error in
            defer { self?.read(from: stream) }
            guard let self = self,
                  let data = data else { return }

            if let error = error {
                Log.network.error("\(StreamChatError.failedToReadFromStream(error: error))")
            }

            if let message = self.constructMessage(with: data) {
                self.delegate?.didReceiveMessage(message)
            }
        }
    }

    private func constructMessage(with data: Data) -> Message? {
        guard let strings = String(data: data,
                                   encoding: .utf8)?.components(separatedBy: String.StreamAffix.Infix.receive),
              let name = strings.first,
              let message = strings.last else {
            Log.logic.error("\(StreamChatError.failedToConvertDataToString)")
            return nil
        }

        let isSystemMessage: Bool = strings.count <= 1

        if isSystemMessage {
            return Message(sender: DefaultUser.system, text: message, dateTime: Date())
        } else {
            let sender: User = (name == user.name) ? user : User(name: name, senderType: .someoneElse)
            return Message(sender: sender, text: message, dateTime: Date())
        }
    }

    private func write(_ streamData: Data) {
        streamTask?.write(streamData, timeout: ConnectionSetting.writeTimeout) { error in
            if let error = error {
                Log.network.error("\(StreamChatError.failedToWriteOnStream(error: error))")
            }
        }
    }
}

// MARK: - URLSessionStreamDelegate

extension ChatRoom: URLSessionStreamDelegate {

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        streamTask?.closeRead()
        streamTask?.closeWrite()
    }
}
