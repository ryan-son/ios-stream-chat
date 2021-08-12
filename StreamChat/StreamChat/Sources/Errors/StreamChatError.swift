//
//  StreamChatError.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

enum StreamChatError: Error {

    // MARK: ChatRoom Socket Network

    case failedToConvertStringToData(location: String)
    case failedToWriteOnStream(error: Error)
    case failedToReadFromStream(error: Error)
    case failedToConvertDataToString

    // MARK: UI

    case messageNotFound
    case cellTypecastingFailed(toType: String)

    // MARK: View Model

    case indexOutOfBound(requestedIndex: Int, maxIndex: Int)

    // MARK: Common

    case unknown(location: String)
}

extension StreamChatError: CustomStringConvertible {

    var description: String {
        switch self {
        case .failedToConvertStringToData(let location):
            return "문자열을 스트림 데이터로 변환하지 못했습니다. Location: \(location)"
        case .failedToWriteOnStream(let error):
            return "Output stream에 쓰기 작업이 실패하였습니다. Error: \(error)"
        case .failedToReadFromStream(let error):
            return "Input stream을 읽어들이던 중에 문제가 발생했습니다. Error: \(error)"
        case .failedToConvertDataToString:
            return "데이터를 문자열로 변환하지 못해 메시지를 만들지 못했습니다."
        case .messageNotFound:
            return "해당 index에는 메시지가 없습니다."
        case .cellTypecastingFailed(let type):
            return "해당 Cell은 \(type) 타입으로 변환할 수 없습니다."
        case let .indexOutOfBound(requestedIndex, maxIndex):
            return "요청한 index(\(requestedIndex))가 최대 index(\(maxIndex))보다 큽니다."
        case .unknown(let location):
            return "알 수 없는 에러가 발생했습니다. Location: \(location)"
        }
    }
}
