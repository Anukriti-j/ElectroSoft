# ElectroSoft

ElectroSoft is a SwiftUI-based iOS app for managing utility operations. It includes authentication, role-aware navigation, theming, and list-driven workflows for employees and clients, backed by a REST API.

## Features
- Email/password authentication with session persistence via Keychain and graceful login validation UI.
- Role-based tab navigation that surfaces dashboards, employee management, client lists, billing, issues, and invoices depending on user type/roles.
- Client and employee lists with search, filters, sort menus, pagination, pull-to-refresh, and optimistic delete (employees).
- Theming support with quick theme switching and persisted user preference.
- Network reachability monitoring with an in-app banner for offline states.
- Modular dependency container wiring API client, repositories, storage, and theme/session/network managers.

## Screenshots
<img width="453" height="927" alt="Screenshot 2025-12-23 at 5 48 59 PM" src="https://github.com/user-attachments/assets/376f7618-abda-4df7-a6a0-08697021b25c" />
<img width="456" height="893" alt="Screenshot 2025-12-23 at 5 48 51 PM" src="https://github.com/user-attachments/assets/86a531fa-1fca-4f2c-a682-18d76cf83742" />
<img width="444" height="922" alt="Screenshot 2025-12-23 at 5 29 44 PM" src="https://github.com/user-attachments/assets/04df937a-67b4-4dbd-804b-8c9a07f2c6a4" />
<img width="438" height="912" alt="Screenshot 2025-12-23 at 5 29 17 PM" src="https://github.com/user-attachments/assets/eab2b25a-4686-48cd-84e9-9d23f82289bb" />
<img width="445" height="916" alt="Screenshot 2025-12-23 at 5 29 04 PM" src="https://github.com/user-attachments/assets/c16a4aff-4d63-4c2d-b201-c08f437363d4" />
<img width="434" height="911" alt="Screenshot 2025-12-23 at 5 28 43 PM" src="https://github.com/user-attachments/assets/0bf569cf-8388-4af6-bf5e-4a88173df8eb" />
<img width="437" height="912" alt="Screenshot 2025-12-23 at 5 28 13 PM" src="https://github.com/user-attachments/assets/d549ca95-87e2-4496-bd86-17ec18ff7a78" />

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

