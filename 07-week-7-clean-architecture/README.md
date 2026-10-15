# Week 7 - Clean Architecture

## Lab 1: Audit the Old Project Layers

Source: existing Week 6 Flutter project, Campus Notify.

### 1. Map Files to Layers

| File | Current layer | Problem / observation |
|---|---|---|
| `lib/main.dart` | Application composition | Firebase initialization and GoRouter configuration are combined in the entry point. |
| `lib/data/api_client.dart` | Data / infrastructure | Configures Dio and token-refresh interceptors. |
| `lib/data/auth_repository.dart` | Data | `AuthSession` and mock repository implementation share one file; a domain repository contract is not yet defined. |
| `lib/data/token_store.dart` | Data / infrastructure | Wraps FlutterSecureStorage. |
| `lib/messaging/push_service.dart` | Messaging / infrastructure | Integrates Firebase Messaging and local notifications. |
| `lib/pages/announcement_page.dart` | Presentation | Displays static announcement details. |
| `lib/pages/home_page.dart` | Presentation | Displays the home page and delegates logout to the auth notifier. |
| `lib/pages/login_page.dart` | Presentation | Handles login inputs, loading, errors, and navigation. |
| `lib/providers/auth_provider.dart` | Presentation state management / DI | Defines Riverpod providers and authentication state. |

### 2. Three Classic Violations

The searches were performed using PowerShell `Select-String` because `rg` was unavailable.

**Search 1 — Network/database/storage in presentation**

Patterns: `Dio(`, `http.`, `openDatabase`, `SharedPreferences.getInstance`, `FlutterSecureStorage`

Result: No matches in the existing presentation files.

**Search 2 — Business logic inside widgets**

Patterns: `DateFormat`, `jsonDecode`, `.toIso8601String`

Result: No matches in the existing presentation files.

**Search 3 — Manual instantiation**

Patterns: `Repository(`, `Dio(BaseOptions`

Result: `lib/providers/auth_provider.dart` contains `return AuthRepository();` inside a Riverpod provider. This is a dependency construction point to review, not proof of direct repository construction inside a page.

### 3. Sketch the Target Structure

The existing announcement feature is the candidate for refactoring. No new feature is being introduced.

```text
lib/
├── core/
│   └── failures.dart
├── features/
│   └── announcements/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/
│       │   ├── models/
│       │   └── repositories/
│       └── presentation/
│           ├── providers/
│           └── pages/
├── messaging/
├── routes.dart
└── main.dart
```

This is the proposed target structure. Refactoring has not yet been completed.

### Checklist

- [x] Map existing files to layers
- [x] Run the three searches
- [x] Identify initial refactoring items
- [x] Sketch the target structure
- [ ] Refactor the existing feature
- [ ] Add and run tests
- [ ] Capture screenshots

## Screenshots

Save Lab 1 audit, test, and application screenshots in this directory.
