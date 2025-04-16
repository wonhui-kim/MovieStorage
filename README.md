# MovieStorage

### 🛠 개발 환경

<img width="89" src="https://img.shields.io/badge/iOS-12.0+-silver"> <img width="95" src="https://img.shields.io/badge/Xcode-14.1-blue"> <img width="95" src="https://img.shields.io/badge/Swift-5.7.1-orange"> 

### :sparkles: Skills & Tech Stack
- code based UI
- Auto Layout

### 🔗 작성한 Issues & PR
- [[FEAT] 검색, 즐겨찾기 탭바 생성 및 AppDelegate, SceneDelegate 수정 #10](https://github.com/wonhui-kim/MovieStorage/pull/10)
- [[FEAT] 첫 번째 탭 검색 탭 생성 (검색 전 화면, 검색 결과 화면, 키보드 엔터키 "검색") #12](https://github.com/wonhui-kim/MovieStorage/pull/12)
- [[FEAT] 검색 API 함수 구현 (검색 쿼리 결과 반환 함수, JSON 대응 Model 생성) #15](https://github.com/wonhui-kim/MovieStorage/pull/15)
- [[FEAT] 검색 완료 화면 구현 (UICollectionViewCell layout배치, 결과 화면 로드, url->UIImage 함수 구현) #16](https://github.com/wonhui-kim/MovieStorage/pull/16)
- [[HOTFIX] iOS 12.4에서 검색어 입력 시 검은 화면이 뜨는 에러 해결 (definesPresentationContext 설정) #18](https://github.com/wonhui-kim/MovieStorage/pull/18)
- [[FEAT] 검색어 입력 시 키보드 "검색" 버튼 클릭 시 결과 로드되도록 구현 변경 (updateSearchResults -> searchBarSearchButtonClicked 변경) #21](https://github.com/wonhui-kim/MovieStorage/pull/21)
- [[FEAT] 검색 결과 하단 스크롤 시 다음 페이지 결과 호출 (기존 검색 API 함수에 page 매개변수 추가, 포스터 이미지 없을 시 default 이미지 할당) #23](https://github.com/wonhui-kim/MovieStorage/pull/23)
- [[FEAT] 검색 결과에서 즐겨찾기 선택창 및 표시 구현 (actionSheet 구현, 즐겨찾기된 cell 표시) #25](https://github.com/wonhui-kim/MovieStorage/pull/25)
- [[FEAT] 즐겨찾기 탭 화면 구현 (NotificationCenter를 이용하여 즐겨찾기 추가, 삭제 시 CollectionView에 반영) #27](https://github.com/wonhui-kim/MovieStorage/pull/27)
- [[FEAT] 즐겨찾기 데이터 영속화 구현 (Core Data 사용) #29](https://github.com/wonhui-kim/MovieStorage/pull/29)
- [[FEAT] 즐겨찾기 목록 drag&drop으로 순서 조정 (UICollectionViewDragDelegate, UICollectionViewDropDelegate) #30](https://github.com/wonhui-kim/MovieStorage/pull/30)
- [Issues](https://github.com/wonhui-kim/MovieStorage/issues?q=is%3Aissue+is%3Aclosed)


### 커밋 스타일 가이드
- Commit Style Guide
  - [FEAT] : 기능 추가, 라이브러리 추가, 에셋 추가, 새로운 View 생성
  - [CHORE] / [FIX] : 코드 수정, 내부 파일 수정
  - [DOCS] : README나 WIKI 등의 문서 개정
  - [HOTFIX] : 긴급 오류 수정

- Issue Style Guide
  ```
  [<PREFIX>] <Description> 
  ex) [FEAT] 검색창 구현
  ``` 
  
- Pull Request Style Guide
  - Issue와 동일
  - code changed 300 이하
  - Merge가 완료된 PR 브랜치는 다시 사용하지 않는다면 삭제


### 브랜치 전략
- 브랜치 플로우
  ```
  1. Issue를 생성한다.
  2. feature 브랜치를 생성한다.
  3. feature 브랜치 내부에서 Add - Commit - Push - Pull Request 의 과정을 거친다.
  4. Pull Request 작성자가 merge를 할 Branch로 merge 한다.
  5. 종료된 Issue와 Pull Request의 Project를 관리한다.
  6. 종료된 Pull Request branch는 삭제한다.
  ```


### 🌿 프로젝트 폴더 구조
<img width="344" src="https://user-images.githubusercontent.com/96123303/209781882-e25ee9ee-d29c-45b4-b250-5b7e570688d0.png">


### 기본 구현

| 구현 요구 사항 | 구현 여부 |
|--------------|---------|
|앱은 하단 탭바를 가지며 총 두개의 하단 탭으로 구성| O |
|첫번째 탭은 검색, 두번째 탭은 즐겨찾기 | O |
|앱 첫 진입 시 화면 검색 탭에서 시작 | O |
|앱 첫 진입 시 네비게이션 바에 검색창이 노출 | O |
|앱 첫 진입 시 네비게이션 바 하단 목록 영역은 "검색 결과가 없습니 다."로 노출 | O |
|검색 창 클릭 시 키보드가 올라오며 키보드의 엔터키 이름은 "검색"으로 설정 | O |
|검색어 입력 후 키보드의 검색 클릭 시 키보드가 사라지며 네비게이션 바 아래로 검색 결과가 노출 | O |
|검색어 입력 후 키보드의 검색 클릭 시 한 줄에 영화 두개씩 노출하는 카드뷰 형태의 세로 스크롤 형 목록  | O |
|검색어 입력 후 키보드의 검색 클릭 시 스크롤 중이더라도 네비게이션 바의 검색창은 함께 스크롤되지 않고 고정 | O |
|각 영화 아이템은 위쪽에 영화 포스터 이미지, 아래쪽에 영화 제목, 연도, 타입이 표시 | O |
|검색결과 목록을 최하단으로 내렸을 때 API를 이용하여 다음페이지를 불러와 노출 | O |
|검색결과가 없는 경우 "검색 결과가 없습니다."로 노출| O |
|검색 결과 중 영화 클릭 시 선택 창이 뜨며 "즐겨찾기" or "취소" 를 선택 가능|O|
|"즐겨찾기"를 선택 시 해당 영화정보를 즐겨찾기 탭에서 조회 가능|O|
|이미 즐겨찾기 한 영화를 선택한 경우 "즐겨찾기" 대신 "즐겨찾기 제거"를 노출|O|
|즐겨찾기 된 영화는 검색 목록에서 알아볼 수 있도록 아이콘 혹은 텍스트를 노출|O|
|이미 즐겨찾기 한 영화를 선택한 경우 "즐겨찾기" 대신 "즐겨찾기 제거"를 노출|O|
|하단 즐겨찾기 탭 선택 시 네비게이션 바에서 검색창이 사라지고 "내 즐겨찾기"라는 Title이 노출|O|
|하단 즐겨찾기 탭 선택 시 현재까지 즐겨찾기한 영화들의 목록이 검색결과 탭과 동일한 디자인으로 노출|O|
|하단 즐겨찾기 탭에서 영화를 클릭 시 선택 창이 뜨며 "즐겨찾기 제거" or "취소"를 선택 가능|O|
|하단 즐겨찾기 탭에서 "즐겨찾기 해제"를 누르는 순간 해당 영화는 목록에서 즉시 제거|O|
|즐겨찾기 탭은 별도의 페이징 없이 한 번에 모든 데이터를 로딩|O|
|즐겨찾기한 영화들의 순서를 드래그&드롭으로 조절 가능| O |
|즐겨찾기 한 영화 데이터가 앱을 종료 후 재시작하더라도 유지되도록 해당 데이터를 디바이스에 저장| O |
|앱을 재시작 후 즐겨찾기 탭에 들어갔을 때 재시작 직전과 동일한 상태로 노출|O|

### 📱 시연 영상
|검색 결과 있을 때|검색 결과 없을 때|검색 결과 즐겨찾기 추가|검색 결과 즐겨찾기 삭제|
|-------------|-------------|------------------|-----------------|
|<img src="https://user-images.githubusercontent.com/96123303/209789417-d11d4d28-576e-46d0-8abc-89712c4ccc97.gif" width=100/>|<img src="https://user-images.githubusercontent.com/96123303/209789614-551f194f-bc49-488d-850f-371e3eb01678.gif" width=100/>|<img src="https://user-images.githubusercontent.com/96123303/209789805-dcca10be-08d3-410f-9459-dfc2be5ab183.gif" width=100/>|<img src="https://user-images.githubusercontent.com/96123303/209794095-ebfb92df-7e5d-4e7e-87ad-6bf73a1f611d.gif" width=100/>|

|즐겨찾기 삭제|즐겨찾기 순서 변경|즐겨찾기 데이터 영속화|
|----------|-------------|----------------|
|<img src="https://user-images.githubusercontent.com/96123303/209789256-2a4e0685-8def-407c-b05b-6814c719a854.gif" width=100/>|<img src="https://user-images.githubusercontent.com/96123303/209789047-3b691a47-35aa-434a-892b-531fa5fee672.gif" width=100/>|<img src="https://user-images.githubusercontent.com/96123303/209788858-aac94765-bafe-4443-9cc1-6f11c89051f2.gif" width=100/>|
