//
//  StreamData.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/16.
//

import Foundation

struct StreamData {

    enum MessageFormat {
        case join(username: String)
        case send(message: String)
        case leave
    }

    private enum Prefix {
        static let join = "USR_NAME::"
        static let send = "MSG::"
        static let leave = "LEAVE::"
    }

    enum Infix {
        static let receive = "::"
    }

    private enum Suffix {
        static let endOfMessage = "::END"
    }

    static func make(_ format: MessageFormat) -> Data? {
        switch format {
        case .join(let username):
            return "\(Prefix.join)\(username)\(Suffix.endOfMessage)".data(using: .utf8)
        case .send(let message):
            return "\(Prefix.send)\(message)\(Suffix.endOfMessage)".data(using: .utf8)
        case .leave:
            return (Prefix.leave + Suffix.endOfMessage).data(using: .utf8)
        }
    }
}
