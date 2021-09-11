//
//  OSLog+Extension.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

import OSLog

extension OSLog {

    static let subsystem = Bundle.main.bundleIdentifier!
}

struct Log {

    static let flowCheck = Logger(subsystem: OSLog.subsystem, category: "Flow check")
    static let logic = Logger(subsystem: OSLog.subsystem, category: "Logic")
    static let network = Logger(subsystem: OSLog.subsystem, category: "Network")
    static let ui = Logger(subsystem: OSLog.subsystem, category: "UI")
}
