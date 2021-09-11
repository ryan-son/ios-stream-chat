//
//  ChatRoomSocketDelegate.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

protocol ChatRoomSocketDelegate: AnyObject {

    func didReceiveMessage(_ message: Message)
}
