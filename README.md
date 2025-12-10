# ElectroSoft

ElectroSoft is a SwiftUI-based iOS app for managing utility operations. It includes authentication, role-aware navigation, theming, and list-driven workflows for employees and clients, backed by a REST API.

## Features
- Email/password authentication with session persistence via Keychain and graceful login validation UI.
- Role-based tab navigation that surfaces dashboards, employee management, client lists, billing, issues, and invoices depending on user type/roles.
- Client and employee lists with search, filters, sort menus, pagination, pull-to-refresh, and optimistic delete (employees).
- Theming support with quick theme switching and persisted user preference.
- Network reachability monitoring with an in-app banner for offline states.
- Modular dependency container wiring API client, repositories, storage, and theme/session/network managers.

## Tech Stack
- Swift 5.10+, SwiftUI, NavigationStack, async/await.
- MVVM with repositories for API access.
- Keychain-backed session storage (`Core/Storage/KeyChainManager.swift`) and session management (`Core/Storage/SessionManager.swift`).
- Custom theming system (`Core/Theme`) and shared UI components (`Shared/Components`).
- REST client with request builders, interceptors, unified responses, and typed endpoints (`Core/Networking`).

## Project Structure
```
ElectroSoft/
├─ App/                    # App entry, root view, DI container
├─ Core/                   # Constants, networking, storage, theme, utilities
├─ Features/               # Feature modules (Auth, Clients, Employee, Dashboard, etc.)
├─ Shared/                 # Reusable components, models, alerts, modifiers
└─ Resources/              # Assets and colors
```

## Architecture
- **Pattern:** MVVM with feature-scoped view models coordinating repositories and exposing view state to SwiftUI views.
- **Dependency injection:** `AppDependencyContainer` constructs shared services (API client, repositories, managers) and is injected into feature views.
- **Networking:** `APIClient` + `RequestBuilder` + endpoint enums under `Core/Networking/Endpoints`; responses flow through `UnifiedAPIResponse`.
- **Repositories:** Feature-specific repositories wrap network calls and map to domain models (e.g., `AuthRepository`, `ClientRepository`, `EmployeeRepository`, `AddEmployeeRepository`).
- **State & storage:** `SessionManager` (Keychain-backed) for auth/session, `ThemeManager` for persisted theme, `NetworkMonitor` for reachability.
- **UI composition:** Shared components (tab bar, filters, sort menus, profile panel) in `Shared/Components`; role-based navigation defined in `MainTabView`.

## Requirements
- Xcode 16.0+ (iOS deployment target 18.5).
- iOS 18.5+ simulator or device.

## Setup & Run
1. Clone the repo and open `ElectroSoft.xcodeproj` in Xcode.
2. Select a development team in Signing & Capabilities for the `ElectroSoft` target.
3. Configure the API base URL in `Core/Constants/APIConstants.swift` (default points to a dev tunnel).
4. Build and run on an iOS 18.5 simulator or device.

## Configuration
- API base URL: `Core/Constants/APIConstants.swift` (`APIConstants.baseURL`).
- Theme preference persists via `UserDefaults` (`StringConstants.savedThemeKey`).
- Auth/session tokens are stored securely in Keychain via `SessionManager`.

## Notes
- No automated tests are included yet.
- Role/tab availability is governed by `TabItem` logic in `Shared/Components/MainTabView.swift`.

## Troubleshooting
- If API calls fail, confirm the base URL is reachable and that certificates are trusted on the device/simulator.
- If you see a network offline banner, verify connectivity; the app listens to `NetworkMonitor` reachability updates.

