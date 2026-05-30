# GitExplorer

GitHub 사용자 검색, 프로필 조회, 즐겨찾기 관리 및 Apple Watch 연동을 지원하는 iOS 앱이다.
Combine과 async/await를 실전 구조로 혼합하여 설계한 아키텍처 학습 프로젝트이다.

---

## 스크린샷

<div align="center">
  <img width="30%" alt="iOS" src="https://github.com/user-attachments/assets/4bf7148c-a6a3-41ca-a906-7340a08c4eb6" />
  <img width="30%" alt="Widget" src="https://github.com/user-attachments/assets/72105c67-bec3-428b-b52b-209eafdd2c20" />
  <img width="20%" alt="Watch" src="https://github.com/user-attachments/assets/00ffb26f-5683-49ef-bcb5-37e59de388b2" />
</div>

---

## 핵심 기능

- GitHub 사용자 검색 (debounce 기반 반응형 검색)
- 사용자 프로필 조회 (Repo / Followers / Following)
- 즐겨찾기 추가 및 삭제
- 즐겨찾기 데이터 자동 갱신 (30초 타이머)
- Apple Watch 즐겨찾기 동기화
- 홈 화면 위젯 (Small / Medium)

---

## 요구사항

- iOS 18.5+
- watchOS 11.5+
- Xcode 16+

---

## 기술 스택

- SwiftUI
- Combine
- async/await
- WatchConnectivity
- WidgetKit
- GitHub REST API
- UserDefaults / App Group

---

## 아키텍처 구조

MVVM 기반 구조를 유지하면서 Combine과 async/await를 혼합하여 사용하였다.

```
View → ViewModel → Service → GitHub API
                 ↘ WatchConnectivity ↙
                 ↘ WidgetKit (App Group) ↙
```

---

## 파일 구조

```
GitExplorer/
├── Mock/
│   └── MockData.swift
├── Models/
│   └── TotalProfile.swift
├── Services/
│   ├── GitHubNetworkService.swift
│   └── WatchConnectivityService.swift
├── Utilities/
│   └── Constants.swift
├── ViewModels/
│   ├── FavoriteViewModel.swift
│   ├── ProfileViewModel.swift
│   └── SearchViewModel.swift
├── Views/
│   ├── AvatarView.swift
│   ├── FavoritesView.swift
│   ├── ProfileView.swift
│   └── SearchView.swift
├── ContentView.swift
└── GitExplorerApp.swift

GitExplorerWatch Watch App/
├── Models/
│   └── GithubUser.swift
├── Services/
│   └── WatchConnectivityService.swift
├── ViewModels/
│   └── WatchFavoriteViewModel.swift
├── Views/
│   ├── AvatarView.swift
│   ├── FavoritesListView.swift
│   └── ProfileDetailView.swift
├── ContentView.swift
└── GitExplorerWatchApp.swift

GitExplorerWidget/
├── Mock/
│   └── MockData.swift
├── Models/
│   └── GithubUser.swift
├── Services/
│   └── NetworkService.swift
├── Views/
│   ├── MediumWidgetView.swift
│   ├── SharedView.swift
│   └── SmallWidgetView.swift
├── Widgets/
│   ├── MultiGitExplorerWidget.swift
│   └── SingleGitExplorerWidget.swift
└── GitExplorerWidgetBundle.swift
```

| 파일 | 역할 |
|------|------|
| `MockData.swift` | 프리뷰용 Mock 데이터 |
| `TotalProfile.swift` | GithubUser, GithubRepo, TotalProfile 모델 |
| `GitHubNetworkService.swift` | GitHub API 호출 (Combine + async/await) |
| `WatchConnectivityService.swift` (iOS) | Watch로 즐겨찾기 데이터 전송 |
| `Constants.swift` | API 토큰 등 상수 |
| `SearchViewModel.swift` | 검색 파이프라인 (debounce, switchToLatest) |
| `ProfileViewModel.swift` | 프로필 + repos + followers 동시 호출 |
| `FavoriteViewModel.swift` | 즐겨찾기 추가/삭제 + 30초 자동 갱신 |
| `AvatarView.swift` | AsyncImage 공용 컴포넌트 |
| `SearchView.swift` | 검색 화면 |
| `ProfileView.swift` | 프로필 상세 화면 |
| `FavoritesView.swift` | 즐겨찾기 화면 + 자동 갱신 |
| `ContentView.swift` | TabView 루트 |
| `GitExplorerApp.swift` | 앱 진입점 |
| `GithubUser.swift` (Watch) | Watch용 GithubUser 모델 |
| `WatchConnectivityService.swift` (Watch) | iOS에서 데이터 수신 |
| `WatchFavoriteViewModel.swift` | Watch 즐겨찾기 상태 관리 |
| `FavoritesListView.swift` | Watch 즐겨찾기 목록 화면 |
| `ProfileDetailView.swift` | Watch 프로필 상세 화면 |
| `GitExplorerWatchApp.swift` | Watch 앱 진입점 |
| `MockData.swift` (Widget) | Widget용 Mock 데이터 |
| `GithubUser.swift` (Widget) | Widget용 GithubUser 모델 |
| `NetworkService.swift` (Widget) | Widget용 GitHub API 호출 (async/await) |
| `SmallWidgetView.swift` | Small 위젯 화면 |
| `MediumWidgetView.swift` | Medium 위젯 화면 |
| `SharedView.swift` | AvatarView, StatLabel 등 위젯 공용 컴포넌트 |
| `SingleGitExplorerWidget.swift` | Single Widget Provider / Entry |
| `MultiGitExplorerWidget.swift` | Multi Widget Provider / Entry |
| `GitExplorerWidgetBundle.swift` | Widget 진입점 |

---

## 주요 구현 내용

### 1. Reactive Search Pipeline (Combine)

검색은 Combine 스트림으로 구성되어 있다.

- debounce: 입력 지연 처리
- removeDuplicates: 중복 요청 제거
- switchToLatest: 이전 요청 취소
- retry / error handling

---

### 2. 네트워크 구조 (Hybrid)

GitHubNetworkService는 두 가지 방식으로 구성된다.

- Combine Publisher 기반 요청
- async/await 기반 비동기 요청
- Generic API 처리 구조

---

### 3. 즐겨찾기 시스템

FavoriteViewModel은 상태 중심 구조이다.

- names: source of truth (저장된 ID)
- users: UI 바인딩 데이터
- UserDefaults 기반 영속성
- Timer 기반 자동 갱신 (30초)

---

### 4. 동시성 처리

즐겨찾기 데이터는 두 방식으로 처리된다.

- 순차 처리 (async/await)
- 병렬 처리 (TaskGroup)

→ 성능 및 구조 비교 실험 목적

---

### 5. Apple Watch 연동

iOS ↔ Watch 간 즐겨찾기 데이터를 동기화한다.

- sendMessageData 기반 실시간 전송 (현재 사용)
- updateApplicationContext 기반 상태 동기화 (대체 방식)

WatchConnectivity를 통해 JSON 데이터를 전달하며 상태를 동기화한다.

---

### 6. Widget

즐겨찾기 유저 정보를 홈 화면 위젯으로 표시한다.

- Small: 즐겨찾기 첫 번째 유저 정보
- Medium: 즐겨찾기 첫 번째, 두 번째 유저 정보
- App Group을 통해 앱과 위젯 간 데이터 공유
- 6시간 주기 자동 갱신

---

## 시작하기

토큰 없이도 앱은 동작하지만, GitHub API의 rate limit으로 인해 요청 횟수가 제한된다.

제한 없이 사용하려면 `Constants.swift`에 GitHub Personal Access Token을 추가한다.

```swift
struct Constants {
    static let token = "Bearer YOUR_TOKEN_HERE"
}
```

토큰 발급: [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)

---

## 개발 과정

[블로그에서 전체 개발 과정 보기](https://haroldfromk.github.io/categories/gitexplorer/)

---

## Day별 구현 내용

- **Day 1**: 실시간 검색 파이프라인 (debounce, switchToLatest, retry, catch)
- **Day 2**: 프로필 화면 (CombineLatest3, 제네릭 NetworkService)
- **Day 3**: 즐겨찾기 (PassthroughSubject, UserDefaults)
- **Day 4**: 자동 갱신 (Timer, MergeMany, async/await, TaskGroup)
- **Day 5**: WatchOS 연동 (WatchConnectivity, WCSession)
- **Day 6**: Widget (WidgetKit, App Group, TimelineProvider)

---

## 추후 보완 예정

### iOS 앱
- `ObservableObject` + `@Published` → `@Observable` 마이그레이션
- `ProfileViewModel` 로딩/성공/실패 상태 관리 추가
- `FavoriteViewModel` → `scan` 으로 리팩토링
- `FavoritesView` → SwiftData 연결 (UserDefaults 제거)
- 에러 스트림 `merge`로 통합하여 Alert 띄우는 구조 추가
- 에러 스트림을 Subject로 외부에 전달하는 구조 개선

### Apple Watch
- `ProfileDetailView` 레포 목록 API 연결

### Widget
- App Intent 적용 (유저 선택 커스터마이징)
- WatchOS Widget 추가