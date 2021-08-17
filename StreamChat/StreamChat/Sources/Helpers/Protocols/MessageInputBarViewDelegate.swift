//
//  MessageInputBarViewDelegate.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

protocol MessageInputBarViewDelegate: AnyObject {

    func didTapSendButton(message: String)
    func showMaxLengthExceededAlert()
    func showForbiddenStringContainedAlert()
}
