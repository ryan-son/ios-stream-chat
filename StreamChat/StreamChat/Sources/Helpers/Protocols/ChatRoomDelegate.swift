//
//  ChatRoomDelegate.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

protocol ChatRoomDelegate: AnyObject {

    func didReceiveMessage(_ message: Message)
}
