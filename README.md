# 🌸 Hikari Client — 간편송금 앱 (Client)

> _Lightweight, fast, and friendly remittance client for Hikari._

[![CI](https://img.shields.io/github/actions/workflow/status/hikaripay11/hikari-client/ci.yml?label=CI)](../../actions)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/hikaripay11/hikari-client/codeql.yml?label=CodeQL)](../../actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Commits-Conventional-FFA500?logo=git)](https://www.conventionalcommits.org/ko/v1.0.0/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-blue.svg)](./CONTRIBUTING.md)

> ⚙️ **스택 가정(수정 가능):**
> - (옵션 A) **Flutter** (iOS/Android/Web)
> - (옵션 B) **React Native** (iOS/Android)
> 아래 가이드는 Flutter 기준으로 작성, RN 사용 시 섹션 B를 참고하세요.

---

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Quick Start (Flutter)](#quick-start-flutter)
- [Alternative Start (React-Native)](#alternative-start-react-native)
- [Environments](#environments)
- [Project Structure](#project-structure)
- [Quality Gates](#quality-gates)
- [Branch & Commit](#branch--commit)
- [Release](#release)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)

---

## Features
- 🔐 안전한 로그인 & 기기 바인딩
- 💸 빠른 이체 플로우 (최근 수취인, 즐겨찾기)
- 🧾 거래 내역 / 영수증 보기
- 🌗 라이트/다크 테마
- 🌍 i18n (ko/en) 및 접근성 고려

---

## Architecture
```
Client (Flutter)
 ├─ Presentation (UI, State)
 ├─ Domain (UseCases, Models)
 └─ Data (API, LocalCache)
             ▲
             │ HTTPS + OAuth2/JWT
             ▼
        Hikari Gateway (REST/gRPC)
```

---

## Quick Start (Flutter)
> Flutter 미설치 시: https://docs.flutter.dev/get-started/install

```bash
# 1) 환경 준비
flutter --version
dart --version

# 2) 의존성 설치
flutter pub get

# 3) 런칭
flutter run -d ios      # iOS
flutter run -d android  # Android
flutter run -d chrome   # Web (옵션)
```

### Useful Commands
```bash
# 분석 & 포맷
flutter analyze
dart format .

# 테스트
flutter test

# 릴리즈 빌드(예시)
flutter build ipa     # iOS (Xcode 설정 필요)
flutter build apk     # Android
```

---

## Alternative Start (React-Native)
```bash
# Node, Watchman 설치 필요
npm i -g yarn
yarn

# iOS
cd ios && pod install && cd ..
yarn ios

# Android
yarn android

# Lint/Test
yarn lint
yarn test
```

---

## Environments
루트에 `.env` 또는 `lib/env/*.dart` 사용(선호 방식 선택):

| Key | 설명 | 예시 |
|---|---|---|
| API_BASE_URL | 게이트웨이 베이스 URL | https://api.hikaripay.com |
| OAUTH_CLIENT_ID | OAuth 클라이언트 ID | hikari-client-ios |
| SENTRY_DSN | 오류 트래킹 | (옵션) |

> ⚠️ **주의:** `.env`, 비밀 키는 커밋 금지. GitHub Actions는 **Repository secrets** 사용.

---

## Project Structure
```text
hikari-client/
├─ lib/
│  ├─ app/              # 앱 진입, 라우팅
│  ├─ core/             # 상수, 유틸, 에러, DI
│  ├─ features/
│  │  ├─ auth/
│  │  ├─ transfer/
│  │  ├─ history/
│  │  └─ settings/
│  ├─ data/             # API 클라이언트, DTO, 로컬 저장소
│  └─ l10n/             # 번역
├─ test/
├─ assets/              # 이미지/아이콘/폰트
└─ fastlane/            # (옵션) 배포 자동화
```

---

## Quality Gates
- ✅ **Static Analysis**: `flutter analyze`
- ✅ **Unit Tests**: `flutter test`
- ✅ **CodeQL**: 보안 취약점 스캔
- ✅ **CI**: PR 시 Lint/Test 필수 통과
- ✅ **Pre-commit** (옵션): `dart format`, analyze hook

---

## Branch & Commit
- 기본 브랜치: `main` (보호 규칙 적용)
- 작업 브랜치: `feat/*`, `fix/*`, `chore/*`, `docs/*`
- 커밋 컨벤션: Conventional Commits  
  예) `feat(transfer): add recent recipients carousel`

---

## Release
- 태그 규칙: `vMAJOR.MINOR.PATCH` (예: `v0.4.2`)
- 체인지로그: GitHub Releases 자동 생성 (옵션: release-please)

---

## Roadmap
- [ ] P2P 송금 MVP
- [ ] 거래 영수증 PDF 내보내기
- [ ] 생체인증 FaceID/TouchID
- [ ] 오프라인 송금 예약
- [ ] 푸시 알림 딥링크

---

## Contributing
- 이슈 → 브랜치 → PR → 리뷰 → 머지
- 큰 변경 전에는 Discussion/Issue로 먼저 제안 부탁드립니다.

---

## Security
취약점은 공개 이슈 대신 **보안 메일**로 제보해주세요.  
`security@hikaripay.com` (placeholder)

---

## License
MIT © Hikari
