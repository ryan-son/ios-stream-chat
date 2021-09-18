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
- [5. Trouble shooting](#5-trouble-shooting)

---

<img src="https://user-images.githubusercontent.com/69730931/133730747-df091ceb-29de-4667-a926-355bb5174e43.gif" alt="stream-chat-scenario" width="780"/>

---

# 1. 프로젝트 개요

## 프로젝트 관리

구현 사항을 단계별로 정의 후 필요 기능을 이슈로 남기고 GitHub Project로 관리함으로써 체계적으로 요구기능명세에 따른 개발을 할 수 있도록 목표를 잡았습니다 ([구현 Project](https://github.com/ryan-son/ios-stream-chat/projects/1), [issue board](https://github.com/ryan-son/ios-stream-chat/issues?q=is%3Aissue+is%3Aclosed)).

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

## 메시지 송신

채팅에 참가 중인 사용자들에게 실시간으로 메시지를 보낼 수 있습니다.

<img src="https://user-images.githubusercontent.com/69730931/133869662-eb3932aa-6464-4615-8cf9-a4675442b9ae.gif" alt="stream-chat-send" width="780"/>

## 메시지 수신

채팅에 참가 중인 사용자의 메시지를 받아 실시간으로 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133869821-40c65acd-8e13-4053-a886-c3ae067b59b7.gif" alt="stream-chat-scenario-2" width="780"/>

 

## 사용자 입퇴장 알림

사용자의 입퇴장을 화면에 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133870328-a0cafec7-c127-49de-b960-0573ee07185d.gif" alt="stream-chat-scenario-4" width="780"/>





## 메시지 입력창 탭에 따른 채팅창 위치 이동

메시지 입력을 위해 입력창을 탭하면 최근 대화 위치로 이동하여 마지막으로 이루어진 대화를 보여줍니다.

<img src="https://user-images.githubusercontent.com/69730931/133870091-50f1fe24-b2a2-4675-ac05-14bc4df9d168.gif" alt="stream-chat-scenario-4" width="780"/>


## 사용자 이름 설정 및 채팅방 입퇴장

사용자가 원하는 이름을 지정하여 채팅방에 입장할 수 있으며, 퇴장 시 퇴장 메시지를 띄우도록 메시지를 전달합니다. 

<img src="https://user-images.githubusercontent.com/69730931/133871793-f7d106f3-52e6-42a4-a579-414e2a97ede4.gif" alt="stream-chat-scenario-5" width="780"/>



## 에러 및 실행 상황 로깅

통합 로깅 시스템을 통해 앱의 실행 상황과 발생한 에러를 감시하여 보여주고, console app에 기록합니다.

![image](https://user-images.githubusercontent.com/69730931/133869913-483c5c58-fd77-4252-8ed0-12c67249f8ac.png)



# 3. 설계 및 구현

![image](https://user-images.githubusercontent.com/69730931/133871752-8880a458-a873-4237-8bef-dcec4eb605ca.png)


## 메시지 송신



## 메시지 수신



## 사용자 입퇴장 알림



## 메시지 입력창 탭에 따른 채팅창 위치 이동



## 메시지 입력창 탭에 따른 메시지 입력창 위치 이동

## 사용자 이름 설정 및 채팅방 입장


## 에러 및 실행 상황 로깅



## 하나의 Cell 타입을 통해 상대방과 나의 메시지 표현



# 4. 구현 완료 후 개선한 기능 및 수정한 버그

## 메시지 입력창 최대 높이 제한 및 스크롤링 기능 추가

## 메시지 입력 시 최대 글자수 제한, 작성 중인 글자수 표시 및 제한 초과 알림

# 5. Trouble shooting
