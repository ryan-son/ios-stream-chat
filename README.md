# 실시간 채팅

Socket 통신을 통해 참여자 간 실시간 채팅기능을 제공하는 앱

# Table of Contents

- [1. 프로젝트 개요](#1-프로젝트-개요)
  + [MVVM](#mvvm)
  + [코드를 통한 레이아웃 구성](#코드를-통한-레이아웃-구성)
  + [적용된 기술 스택 일람](#적용된-기술-스택-일람)
- [2. 기능](#2-기능)
- [3. 설계 및 구현](#3-설계-및-구현)
- [4. Trouble shooting](#4-trouble-shooting)

---

<img src="https://user-images.githubusercontent.com/69730931/133730747-df091ceb-29de-4667-a926-355bb5174e43.gif" alt="stream-chat-scenario" width="780"/>

---

# 1. 프로젝트 개요

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



# 3. 설계 및 구현



# 4. Trouble shooting

