# 실시간 채팅

Socket 통신을 통해 참여자 간 실시간 채팅기능을 제공하는 앱

# Table of Contents

- [1. 프로젝트 개요](#1-프로젝트-개요)
  + [프로젝트 관리](#프로젝트-관리)
  + [MVVM](#mvvm)
  + [코드를 통한 레이아웃 구성](#코드를-통한-레이아웃-구성)
  + [적용된 기술 스택 일람](#적용된-기술-스택-일람)
- [2. 기능](#2-기능)
- [3. 설계 및 구현](#3-설계-및-구현)
- [4. 구현 완료 후 개선한 기능 및 수정한 버그](#4-구현-완료-후-개선한-기능-및-수정한-버그)
  + [메시지 입력창 최대 높이 제한 및 스크롤링 기능 추가 (Issue #10)](#메시지-입력창-최대-높이-제한-및-스크롤링-기능-추가-issue-10)
  + [메시지 입력 시 최대 글자수 제한, 작성 중인 글자수 표시 및 제한 초과 알림 (Issue #11)](#메시지-입력-시-최대-글자수-제한-작성-중인-글자수-표시-및-제한-초과-알림-issue-11)
- [5. Trouble shooting](#5-trouble-shooting)
  + [메시지 입력창의 높이가 과도하게 늘어나 채팅창 자체를 가리는 문제](#메시지-입력창의-높이가-과도하게-늘어나-채팅창-자체를-가리는-문제)
  + [최초 메시지가 상단 여백 없이 표시되는 문제](#최초-메시지가-상단-여백-없이-표시되는-문제)

---

<img src="https://user-images.githubusercontent.com/69730931/133730747-df091ceb-29de-4667-a926-355bb5174e43.gif" alt="stream-chat-scenario" width="780"/>

---

# 1. 프로젝트 개요

## 프로젝트 관리

- 구현 사항을 단계별로 정의 후 필요 기능을 이슈로 남기고 GitHub Project로 관리함으로써 체계적으로 요구기능명세에 따른 개발을 할 수 있도록 목표를 잡았습니다 ([구현 Project](https://github.com/ryan-son/ios-stream-chat/projects/1), [issue board](https://github.com/ryan-son/ios-stream-chat/issues?q=is%3Aissue+is%3Aclosed)).
- 개선 프로젝트와 issue를 통해 필요하다 판단한 사용자 편의 기능과 수정해야할 버그를 정리하여 업데이트하고 있습니다 ([개선 프로젝트](https://github.com/ryan-son/ios-stream-chat/projects/2), [on-going issue board](https://github.com/ryan-son/ios-stream-chat/issues), [closed issue board](https://github.com/ryan-son/ios-stream-chat/issues?q=is%3Aissue+is%3Aclosed)) 

## MVVM

향후 기능 수정 및 추가가 이루어지더라도 요구한 기능 명세에 따라 동작함을 보장하기 위해 유닛 테스트를 수행할 수 있도록 MVVM 아키텍쳐를 적용하여 뷰와 로직을 분리 하였습니다.

## 코드를 통한 레이아웃 구성

각 View 요소가 어떠한 속성을 가지고 초기화되어 있고, auto-layout을 통해 View들 간 어떠한 제약 관계를 가지고 있는지를 명확히 표현하기 위해 스토리보드 대신 코드를 통해 UI를 구성하였습니다.

## 적용된 기술 스택 일람

| Category   | Stacks                       |
| ---------- | ---------------------------- |
| UI         | - UIKit                      |
| Networking | - Stream<br>- StreamDelegate |
| Logging    | - OSLog                      |



# 2. 기능

## [메시지 송신 (구현 방식 바로가기)](#메시지-송신-기능으로-돌아가기)

채팅에 참가 중인 사용자들에게 실시간으로 메시지를 보낼 수 있습니다.

<img src="https://user-images.githubusercontent.com/69730931/133869662-eb3932aa-6464-4615-8cf9-a4675442b9ae.gif" alt="stream-chat-send" width="780"/>

## [메시지 수신 (구현 방식 바로가기)](#메시지-수신-기능으로-돌아가기)

채팅에 참가 중인 사용자의 메시지를 받아 실시간으로 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133869821-40c65acd-8e13-4053-a886-c3ae067b59b7.gif" alt="stream-chat-scenario-2" width="780"/>

 

## [사용자 입퇴장 알림 (구현 방식 바로가기)](#사용자-입퇴장-알림-기능으로-돌아가기)

사용자의 입퇴장을 화면에 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133870328-a0cafec7-c127-49de-b960-0573ee07185d.gif" alt="stream-chat-scenario-4" width="780"/>





## [메시지 입력창 탭에 따른 메시지 입력창 및 채팅창 위치 이동 (구현 방식 바로가기)](#메시지-입력창-탭에-따른-메시지-입력창-및-채팅창-위치-이동-기능으로-돌아가기)



메시지 입력을 위해 입력창을 탭하면 최근 대화 위치로 이동하여 마지막으로 이루어진 대화를 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133870091-50f1fe24-b2a2-4675-ac05-14bc4df9d168.gif" alt="stream-chat-scenario-4" width="780"/>


## [사용자 이름 설정 및 채팅방 입퇴장 (구현 방식 바로가기)](#사용자-이름-설정-및-채팅방-입퇴장-기능으로-돌아가기)

사용자가 원하는 이름을 지정하여 채팅방에 입장할 수 있으며, 퇴장 시 퇴장 메시지를 띄우도록 메시지를 전달합니다. 

<img src="https://user-images.githubusercontent.com/69730931/133871793-f7d106f3-52e6-42a4-a579-414e2a97ede4.gif" alt="stream-chat-scenario-5" width="780"/>



## [에러 및 실행 상황 로깅 (구현 방식 바로가기)](#에러-및-실행-상황-로깅-기능으로-돌아가기)

통합 로깅 시스템을 통해 앱의 실행 상황과 발생한 에러를 감시하여 보여주고, console app에 기록합니다.

![image](https://user-images.githubusercontent.com/69730931/133869913-483c5c58-fd77-4252-8ed0-12c67249f8ac.png)



# 3. 설계 및 구현

![image](https://user-images.githubusercontent.com/69730931/133871752-8880a458-a873-4237-8bef-dcec4eb605ca.png)

<img width="881" alt="image" src="https://user-images.githubusercontent.com/69730931/133877290-ea0335fe-98cb-41bb-8633-1ddf6438b79e.png">



## [메시지 송신 (기능으로 돌아가기)](#메시지-송신-구현-방식-바로가기)

`ChatRoomViewController`의 요소 중 하나인 `MessageInputBarView`의 textView를 통해 보낼 메시지를 입력한 후 textView 우측에 위치한 보내기 버튼을 탭하면 target으로 등록된 메서드가 실행되며 `MessageInputBarViewDelegate` 타입인 `delegate의 `didTapSendButton(message:)` 메서드를 통해 보낼 메시지를 전달합니다.

```swift
// MARK: - MessageInputBarView

@objc private func sendButtonTapped() {
    guard let delegate = delegate,
          let message = inputTextView.text,
          !message.isEmpty else { return }
    guard !message.contains(StreamData.Infix.receive) else {
        delegate.showForbiddenStringContainedAlert()
        return
    }
    delegate.didTapSendButton(message: message)
    inputTextView.text = ""
}
```

`MessageInputBarViewDelegate`를 구현하고 있는 `ChatRoomViewController`는 전달받은 메시지를 `ChatRoomViewModel`의 `send(message:)` 메서드를 통해 전달합니다.

```swift
// MARK: - MessageInputBarViewDelegate

extension ChatRoomViewController: MessageInputBarViewDelegate {

    func didTapSendButton(message: String) {
        chatRoomViewModel?.send(message: message)
    }
}
```

해당 메서드는 `ChatRoomSocketProvidable` 프로토콜을 준수하는 `ChatRoomSocket`의 `send(message:)`를 실행시켜 최종적으로 `OutputStream`에 `write` 작업을 실행합니다.

```swift
// MARK: - ChatRoomViewModel

func send(message: String) {
    chatRoomSocket.send(message: message)
}

// MARK - ChatRoomSocket

func send(message: String) {
    guard let sendingStreamData: Data = StreamData.make(.send(message: message)) else {
        Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function).localizedDescription)")
        return
    }
    write(sendingStreamData)
}

private func write(_ streamData: Data) {
    streamData.withUnsafeBytes { rawBufferPointer in
        guard let pointer = rawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
            Log.network.error("\(StreamChatError.failedToWriteOnStream.localizedDescription)")
            return
        }
        outputStream?.write(pointer, maxLength: streamData.count)
    }
}
```

 



## [메시지 수신 (기능으로 돌아가기)](#메시지-수신-구현-방식-바로가기)

`ChatRoomSocket`이 `StreamDelegate`의 `stream(_:handle:)`을 구현함으로써 `InputStream`에 전달된 메시지를 읽어옵니다.

```swift
func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case .openCompleted:
        Log.flowCheck.debug("연결 성공!")
    case .hasBytesAvailable:
        readAvailableBytes(from: aStream)
    case .endEncountered:
        leave()
        disconnect()
    case .errorOccurred:
        Log.network.notice("\(StreamChatError.errorOccurredAtStream.localizedDescription)")
    case .hasSpaceAvailable:
        Log.network.info("더 사용할 수 있는 버퍼가 있어요. case: hasSpaceAvailable")
    default:
        Log.network.notice("\(StreamChatError.unknown(location: #function).localizedDescription)")
    }
}
```

 `eventCode` 케이스 중 `hasBytesAvailable`는 `InputStream`으로부터 읽어올 수 있는 바이트가 있다는 의미이므로 해당 바이트를 읽어와 `String` 타입으로 변환하여 메시지를 구성할 수 있습니다.

```swift
private func readAvailableBytes(from stream: Stream) {
    guard let stream = stream as? InputStream else { return }
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ConnectionSetting.maxReadLength)

    while stream.hasBytesAvailable {
        guard let bytesRead = inputStream?.read(buffer, maxLength: ConnectionSetting.maxReadLength) else { return }

        if let error = stream.streamError, bytesRead < .zero {
            Log.network.error("\(StreamChatError.streamDataReadingFailed(error: error).localizedDescription)")
            break
        }

        if let message = constructMessage(with: buffer, length: bytesRead) {
            delegate?.didReceiveMessage(message)
        }
    }
}

private func constructMessage(with buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
    guard let strings = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?
            .components(separatedBy: StreamData.Infix.receive),
          let name = strings.first,
          let message = strings.last else {
        Log.logic.error("\(StreamChatError.failedToConvertByteToString.localizedDescription)")
        return nil
    }

    let isSystemMessage: Bool = strings.count <= 1

    if isSystemMessage {
        return Message(sender: ChatRoomSocket.system, text: message, dateTime: Date())
    } else {
        guard let sender = (name == user?.name) ? user : User(name: name, senderType: .someoneElse) else {
            return nil
        }
        return Message(sender: sender, text: message, dateTime: Date())
    }
}
```

`constructMessage(with:length:)` 메서드를 보시면 아실 수 있으시듯이 시스템 메시지인지 여부를 판단하여 보내는 사람이 시스템인지 판단하고, 이후 아이디를 통해 자신인지 타인인지를 판단하여 메시지를 구성합니다.



## [사용자 입퇴장 알림 (기능으로 돌아가기)](#사용자-입퇴장-알림-구현-방식-바로가기)

사용자 입퇴장 역시 [메시지 수신](#메시지-수신)과 마찬가지로 `InputStream`에 읽어올 수 있는 바이트가 있을 경우에 실행되지만, 시스템 메시지의 특성을 이용하여 시스템이 보낸 메시지인지 여부를 판단합니다. 메시지는 보통 구분자인 `USR_NAME::{ID}::END`, `MSG::{message}::END`와 같이 `::`로 구분되는데, 시스템 메시지는 이러한 구분자를 사용하지 않습니다. 결과적으로 시스템 메시지를 읽어와 구분자로 구분했을 때 요소는 1개라고 판단할 수 있습니다.

```swift
private func constructMessage(with buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
    guard let strings = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?
            .components(separatedBy: StreamData.Infix.receive),
          let name = strings.first,
          let message = strings.last else {
        Log.logic.error("\(StreamChatError.failedToConvertByteToString.localizedDescription)")
        return nil
    }

    let isSystemMessage: Bool = strings.count <= 1

    if isSystemMessage {
        return Message(sender: ChatRoomSocket.system, text: message, dateTime: Date())
    } else {
        guard let sender = (name == user?.name) ? user : User(name: name, senderType: .someoneElse) else {
            return nil
        }
        return Message(sender: sender, text: message, dateTime: Date())
    }
}
```

이후 `ChatRoomViewController`에 위치한 tableView에서 메시지를 표시할 새로운 cell을 생성할 때 메시지를 구성할 때 결정되었던 `sender`를 통해 Cell 타입을 구분하여 새로운 셀을 생성합니다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let message = chatRoomViewModel?.message(at: indexPath.row) else {
        Log.ui.error("\(StreamChatError.messageNotFound.localizedDescription)")
        return MessageTableViewCell()
    }

    switch message.sender.senderType {
    case .system:
        guard let systemMessageCell = tableView.dequeueReusableCell(
                withIdentifier: SystemMessageTableViewCell.reuseIdentifier,
                for: indexPath) as? SystemMessageTableViewCell else {
            Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: SystemMessageTableViewCell.description()).localizedDescription)")
            return SystemMessageTableViewCell()
        }

        systemMessageCell.configure(with: message)
        return systemMessageCell
    default:
        guard let messageCell = tableView.dequeueReusableCell(
                withIdentifier: MessageTableViewCell.reuseIdentifier,
                for: indexPath) as? MessageTableViewCell else {
            Log.ui.error("\(StreamChatError.cellTypecastingFailed(toType: MessageTableViewCell.description()).localizedDescription)")
            return MessageTableViewCell()
        }

        messageCell.configure(with: message)
        return messageCell
    }
}
```



## [메시지 입력창 탭에 따른 메시지 입력창 및 채팅창 위치 이동 (기능으로 돌아가기)](#메시지-입력창-탭에-따른-메시지-입력창-및-채팅창-위치-이동-구현-방식-바로가기)

사용자가 메시지를 입력하기 위해 `MessageInputBarView`의 textView를 탭하면 해당 textView가 firstResponder가 되어 `NotificationCenter`로부터 `keyboardWillShow` 알림을 받을 수 있습니다. 이를 통해 아래와 같이 키보드의 레이아웃에 따라 View의 레이아웃을 조정하는 메서드를 구성할 수 있으며, 여기에 마지막 메시지로 이동할 수 있는 기능을 추가하여 키보드 등장 시 마지막 메시지로 이동할 수 있는 기능을 구현하였습니다.

```swift
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    bottomConstraint?.constant = -keyboardFrame.height

    guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    UIView.animate(withDuration: duration) {
        self.messagesInputBarView.rightComponentStackView.isHidden = false
        self.view.layoutIfNeeded()
        self.scrollToLastMessage()
    }
}
```



## [사용자 이름 설정 및 채팅방 입퇴장 (기능으로 돌아가기)](#사용자-이름-설정-및-채팅방-입퇴장-구현-방식-바로가기)

초기 화면인 `JoinChatRoomViewController`에서 textField를 통해 사용자 이름을 입력 받아 사용합니다.

```swift
@objc private func joinButtonTapped() {
    let chatRoomSocket = ChatRoomSocket()
    let chatRoomViewModel = ChatRoomViewModel(chatRoomSocket: chatRoomSocket)
    let chatRoomViewController = ChatRoomViewController()
    chatRoomViewController.chatRoomViewModel = chatRoomViewModel
    guard let username = usernameTextField.text,
          !username.isEmpty else {
        showUsernameRequiredAlert()
        return
    }
    guard !username.contains(StreamData.Infix.receive) else {
        showForbiddenStringContainedAlert()
        return
    }
    chatRoomViewController.join(with: username)
    navigationController?.pushViewController(chatRoomViewController, animated: true)
}
```

입장 알림은 위 구현에서 `chatRoomViewController.join(with: username)`을 통해 최종적으로 `ChatRoomSocket`에 사용자 이름을 전달하여 `OutputStream`에 입장 메시지를 전달하도록 구성하였습니다.

```swift
func join(with username: String) {
    user = User(name: username, senderType: .me)
    guard let joiningStreamData: Data = StreamData.make(.join(username: username)) else {
        Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function).localizedDescription)")
        return
    }
    write(joiningStreamData)
}
```



## [에러 및 실행 상황 로깅 (기능으로 돌아가기)](#에러-및-실행-상황-로깅-구현-방식-바로가기)

애플의 통합 로깅 시스템 (Unified Logging System)인 OSLog를 이용해 발생한 에러 또는 실행이 정상적으로 이루어지는지 여부를 기록합니다. 기록된 내용은 xcode의 콘솔 또는 mac OS의 콘솔 앱을 통해서 확인할 수 있습니다. 

```swift
Log.network.error("\(StreamChatError.failedToWriteOnStream.localizedDescription)")
Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function).localizedDescription)")
Log.network.error("\(StreamChatError.streamDataReadingFailed(error: error).localizedDescription)")
Log.ui.error("\(StreamChatError.messageNotFound.localizedDescription)")
...
```



## 하나의 Cell 타입을 통해 상대방과 나의 메시지 표현

상대방과 나의 메시지를 표현하는 셀 타입은 `MessageTableViewCell`으로, 해당 타입은 사용자 이름의 이니셜을 표현하는 아이콘과 사용자 이름, 메시지 내용, 보낸 날짜와 같은 요소를 포함하고 있습니다. 메시지가 `ChatRoomSocket`을 통해 구성되는 중 `sender`가 결정되고, 이를 통해 `ChatRoomViewController`의 tableView에서 `dequeueReuseableCell(withIdentifier:for:)` 되는 됩니다. 이후 셀의 스타일을 결정하는 메서드인 `configure(with:)`를 실행하면 전달된 메시지를 통해 `sender`를 알 수 있게되고, 이를 통해 필요한 요소를 스타일링 하는 작업을 수행함으로써 하나의 Cell 타입을 통해 복수의 스타일링을 지원하는 메시지 UI를 구성하였습니다.

```swift
func configure(with message: Message) {
    usernameInitialLabel.text = String(message.sender.name.first ?? Style.unknownUserInitial)
    usernameLabel.text = message.sender.name
    messageLabel.text = message.text
    dateTimeLabel.text = message.dateTime.formatted

    setStyleByUser(with: message) // Sender에 따라 스타일링 수행
    setNeedsLayout()
}

private func setStyleByUser(with message: Message) {
    if message.sender.senderType == .me { // sender가 나인 경우
        usernameInitialLabel.isHidden = true
        usernameLabel.isHidden = true
        contentStackView.alignment = .trailing
        messageLabel.textColor = Style.MessageLabel.textColorForMe
        messageLabel.backgroundColor = Style.MessageLabel.backgroundColorForMe
    } else { // sender가 타인인 경우
        usernameInitialLabel.isHidden = false
        usernameLabel.isHidden = false
        contentStackView.alignment = .leading
        messageLabel.textColor = Style.MessageLabel.textColorForSomeoneElse
        messageLabel.backgroundColor = Style.MessageLabel.backgroundColorForSomeoneElse
    }
}
```



# 4. 구현 완료 후 개선한 기능 및 수정한 버그

## 메시지 입력창 최대 높이 제한 및 스크롤링 기능 추가 ([Issue #10](https://github.com/ryan-son/ios-stream-chat/issues/10))

내용이 긴 메시지를 입력할 때 메시지 입력창의 높이가 과도하게 늘어나 채팅창 자체를 가리는 문제가 발견되었습니다. 

<img src="https://user-images.githubusercontent.com/69730931/133872355-0e0d269b-087b-4c48-a493-7a48232a811a.png" alt="stream-chat-improvement-1" width="270"/>

 

이 문제를 일정 높이를 초과하면 스크롤링을 지원하는 textView가 되게끔 textView를 구성하여 기능을 개선하였습니다.

![ezgif com-resize-8](https://user-images.githubusercontent.com/69730931/133878862-e4b8a149-2eb9-496b-8903-d85e5a4b74ac.gif)



### 구현

먼저, `UITextViewDelegate`의 메서드인 `textViewDidChange(_:)`를 통해 매 글자가 작성될 때마다 `textView`의 `contentSize.height`를 확인하여 지정한 높이를 초과하면 `isOversized` 프로퍼티를 `true`로 변경합니다.

```swift
func textViewDidChange(_ textView: UITextView) {
    isOversized = textView.contentSize.height > Style.InputTextView.maxHeight

    setInputTextCountLabel(to: textView.text.count)
    showInputTextCountLabel(with: textView, whenExceeds: Style.InputTextCountLabel.numberOfLinesToShowLabel)
}
```

이후 `isOversized` 프로퍼티는 프로퍼티 옵저버를 통해 `inputTextView`의 제약을 조정하는 메서드인 `adjustInputTextViewConstraint()`를 호출합니다.

```swift
private var isOversized = false {
    didSet {
        guard oldValue != isOversized else { return }
        adjustInputTextViewConstraint()
    }
}
```

호출된 메서드는 textView의 스크롤 기능을 활성화 시키고, 제약 조절을 통해 높이를 조정하는 등 레이아웃을 조정하는 작업을 수행함으로써 원하는 레이아웃을 구성합니다.

```swift
private func adjustInputTextViewConstraint() {
    inputTextView.isScrollEnabled = isOversized
    textViewHeightConstraint?.isActive = isOversized
    inputTextView.setNeedsUpdateConstraints()
    inputTextView.layoutIfNeeded()
}
```





## 메시지 입력 시 최대 글자수 제한, 작성 중인 글자수 표시 및 제한 초과 알림 ([Issue #11](https://github.com/ryan-son/ios-stream-chat/issues/11))

서버의 요청으로 최대 글자수를 300자로 제한하는 기능을 추가하였습니다. 

![ezgif com-resize-9](https://user-images.githubusercontent.com/69730931/133878866-3933ebee-50cb-4ed8-9ab5-6a4f0752add9.gif)

### 구현

기존 단일 버튼으로 구성된 `sendButton`을 글자수를 표시할 수 있는 `inputTextCountLabel`과 함께 stackView에 넣고 기존의 `sendButton`과 동일한 위치에 위치하도록 하였습니다.

이후 `textViewDidChange(_:)` 메서드를 통해  글자를 입력할 때마다 `inputTextCountLabel`을 업데이트하도록 구성하였습니다.

```swift
func textViewDidChange(_ textView: UITextView) {
    isOversized = textView.contentSize.height > Style.InputTextView.maxHeight

    setInputTextCountLabel(to: textView.text.count)
    showInputTextCountLabel(with: textView, whenExceeds: Style.InputTextCountLabel.numberOfLinesToShowLabel)
}

private func setInputTextCountLabel(to count: Int) {
    inputTextCountLabel.text = "\(String(count))/\(Style.InputTextCountLabel.maxCount)"
}
```

이에 더하여 메시지 입력 창이 두 줄 이상 되지 않았을 경우 글자수를 표시할 필요는 없으므로 한 줄 이상이 되었을 때만 `inputTextCountLabel`이 표시되도록 구성하였습니다.

```swift
private func showInputTextCountLabel(with textView: UITextView, whenExceeds numberOfLines: CGFloat) {
    guard let fontHeight = textView.font?.lineHeight else { return }
    let calculatedNumberOfLines: CGFloat
    calculatedNumberOfLines = textView.intrinsicContentSize.height > .zero
        ? textView.intrinsicContentSize.height / fontHeight
        : textView.contentSize.height / fontHeight
    inputTextCountLabel.isHidden = calculatedNumberOfLines < numberOfLines
}
```

최대 글자수 초과 로직은 아래 메서드와 같이 기존의 text 수, 블럭으로 선택되어 변경될 text 수와 새로 입력되는 replacementText 수를 통해 계산하는 방식을 이용했습니다.

```swift
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let isWithinMaxLength: Bool = textView.text.count + (text.count - range.length) <= Style.InputTextCountLabel.maxCount

    if !isWithinMaxLength {
        delegate?.showMaxLengthExceededAlert()
    }
    return isWithinMaxLength
}
```

위의 메서드에서 확인하실 수 있으시듯이 최대 글자수 초과 시 `MessageInputBarViewDelegate` 타입인 `delegate`를 통해 최대 글자수 초과를 나타내는 알림을 띄우는 메서드를 호출하게끔 하였습니다. 이 delegate는 `ChatRoomViewController`가 구현하고 있습니다.

```swift
// MARK: - ChatRoomViewController
func showMaxLengthExceededAlert() {
    let alert = UIAlertController(title: Style.Alert.maxLengthExceededTitle,
                                  message: Style.Alert.maxLengthExceededMessage,
                                  preferredStyle: .alert)
    present(alert, animated: true)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Style.Alert.timeToDismissMaxLengthExceededAlert) {
        alert.dismiss(animated: true)
    }
}
```

# 5. Trouble shooting

##  메시지 입력창의 높이가 과도하게 늘어나 채팅창 자체를 가리는 문제

[이 링크](#메시지-입력창-최대-높이-제한-및-스크롤링-기능-추가-issue-10)와 같이 발견한 문제를 새로운 기능을 추가함으로써 해결하였습니다.



## 최초 메시지가 상단 여백 없이 표시되는 문제

tableView 상단의 `contentInset`을 추가하는 시점이 문제가 되었습니다. `contentInset`을 추가하는 시점은 subView들의 레이아웃 작업이 완료된 이후인 `viewDidLayoutSubviews()` 이후가 되어야 합니다.

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    messagesTableView.contentInset.top = Style.MessagesTableView.topContentInset
}
```
