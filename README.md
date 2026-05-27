# GitExplorer

GitHub 사용자 검색, 프로필 조회, 즐겨찾기 관리까지 할 수 있는 iOS 앱.
Combine 실전 체화를 목적으로 만든 4일짜리 미니 프로젝트.

---

## 요구사항

- iOS 18.5+
- Xcode 16+

---

## 기술 스택

- SwiftUI
- Combine
- async/await
- UserDefaults
- GitHub REST API

---

## 파일 구조

```
GitExplorer/
├── Mock/
│   └── MockData.swift
├── Models/
│   └── TotalProfile.swift
├── Services/
│   └── GitHubNetworkService.swift
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
```

| 파일 | 역할 |
|------|------|
| `MockData.swift` | 프리뷰용 Mock 데이터 |
| `TotalProfile.swift` | GithubUser, GithubRepo, TotalProfile 모델 |
| `GitHubNetworkService.swift` | GitHub API 호출 (Combine + async/await) |
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

---

## 시작하기

`Constants.swift`에 GitHub Personal Access Token을 추가해야 한다.

```swift
struct Constants {
    static let token = "Bearer YOUR_TOKEN_HERE"
}
```

토큰 발급: [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)

---

## Day별 구현 내용

- **Day 1**: 실시간 검색 파이프라인 (debounce, switchToLatest, retry, catch)
- **Day 2**: 프로필 화면 (CombineLatest3, 제네릭 NetworkService)
- **Day 3**: 즐겨찾기 (PassthroughSubject, UserDefaults)
- **Day 4**: 자동 갱신 (Timer, MergeMany, async/await, TaskGroup)
