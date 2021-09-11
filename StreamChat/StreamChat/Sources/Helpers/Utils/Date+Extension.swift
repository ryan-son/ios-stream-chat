//
//  Date+Extension.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import Foundation

extension Date {

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var formatted: String {
        Date.formatter.string(from: self)
    }
}
