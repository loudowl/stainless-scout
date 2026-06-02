# Stainless Scout — Technical Architecture Document

> **Version:** 1.0 | **Platform:** iOS | **Stack:** SwiftUI + Core Data | **Target:** iOS 17+

---

## 1. Tech Stack

| Layer | Technology | Version | Rationale |
|-------|-----------|---------|-----------|
| **UI Framework** | SwiftUI | iOS 17+ | Declarative UI, native dark mode, modern animations |
| **Local Database** | Core Data | iOS 17+ | Offline-first, complex queries, relationships |
| **In-App Purchase** | StoreKit 2 | iOS 16+ | Native premium unlock, async/await API |
| **Notifications** | UserNotifications | iOS 17+ | Local push alerts for favorites |
| **Persistence (prefs)** | UserDefaults + AppStorage | iOS 17+ | Lightweight user settings |
| **Search** | NSPredicate + FetchRequest | — | Core Data native search |
| **Testing** | XCTest + XCUITest | Xcode 15 | Unit + UI testing |
| **Build Tool** | Xcode | 15.x | Required for iOS development |
| **Dependency Manager** | Swift Package Manager | — | Native, no third-party tools |

> **No third-party dependencies required.** The entire stack is native Apple frameworks, matching the "simple, offline-first" brief.

---

## 2. Project Structure

```
StainlessScout/
├── StainlessScout.xcodeproj/
│   └── project.pbxproj
│
├── StainlessScout/
│   │
│   ├── App/
│   │   ├── StainlessScoutApp.swift          # @main entry point
│   │   ├── AppDelegate.swift                # UNUserNotificationCenter delegate
│   │   └── ContentView.swift               # Root tab container
│   │
│   ├── Core/
│   │   │
│   │   ├── CoreData/
│   │   │   ├── StainlessScout.xcdatamodeld  # Core Data model file
│   │   │   ├── PersistenceController.swift  # NSPersistentContainer setup
│   │   │   └── CoreDataExtensions.swift     # NSManagedObject helpers
│   │   │
│   │   ├── Models/
│   │   │   ├── SDK+CoreDataClass.swift      # SDK managed object
│   │   │   ├── SDK+CoreDataProperties.swift # @NSManaged properties
│   │   │   ├── Acquisition+CoreDataClass.swift
│   │   │   ├── Acquisition+CoreDataProperties.swift
│   │   │   ├── Alternative+CoreDataClass.swift
│   │   │   ├── Alternative+CoreDataProperties.swift
│   │   │   ├── UserStack+CoreDataClass.swift
│   │   │   └── UserStack+CoreDataProperties.swift
│   │   │
│   │   ├── Services/
│   │   │   ├── SDKDataService.swift         # Seed + query SDK catalog
│   │   │   ├── SeedDataLoader.swift         # JSON → Core Data on first launch
│   │   │   ├── NotificationService.swift    # Schedule/cancel local notifications
│   │   │   ├── PremiumService.swift         # StoreKit 2 purchase logic
│   │   │   └── RiskScoreEngine.swift        # Vulnerability score calculation
│   │   │
│   │   ├── ViewModels/
│   │   │   ├── HomeViewModel.swift
│   │   │   ├── SearchViewModel.swift
│   │   │   ├── SDKDetailViewModel.swift
│   │   │   ├── MyStackViewModel.swift
│   │   │   ├── AlertsViewModel.swift
│   │   │   └── PremiumViewModel.swift
│   │   │
│   │   └── Utilities/
│   │       ├── Constants.swift              # App-wide enums and constants
│   │       ├── Extensions+Color.swift       # Brand color definitions
│   │       ├── Extensions+Date.swift        # Date formatting helpers
│   │       ├── Extensions+View.swift        # Reusable view modifiers
│   │       └── AppError.swift              # Typed error enum
│   │
│   ├── Features/
│   │   │
│   │   ├── Home/
│   │   │   ├── HomeView.swift               # Dashboard / overview
│   │   │   ├── RiskSummaryCard.swift        # Stack health snapshot
│   │   │   └── RecentAcquisitionBanner.swift
│   │   │
│   │   ├── Search/
│   │   │   ├── SearchView.swift             # Main SDK search screen
│   │   │   ├── SearchResultRow.swift        # Single SDK result cell
│   │   │   ├── FilterSheet.swift            # Category / risk filter
│   │   │   └── EmptySearchState.swift
│   │   │
│   │   ├── SDKDetail/
│   │   │   ├── SDKDetailView.swift          # Full SDK profile
│   │   │   ├── RiskScoreBadge.swift         # Visual 1–10 gauge
│   │   │   ├── AcquisitionTimeline.swift    # Chronological history
│   │   │   ├── AlternativesList.swift       # Recommended replacements
│   │   │   └── MigrationTemplateView.swift  # 🔒 Premium gate
│   │   │
│   │   ├── MyStack/
│   │   │   ├── MyStackView.swift            # User's tracked SDKs
│   │   │   ├── AddToStackSheet.swift        # Quick-add from search
│   │   │   ├── StackHealthSummary.swift     # Aggregate risk view
│   │   │   └── StackRowItem.swift
│   │   │
│   │   ├── Alerts/
│   │   │   ├── AlertsView.swift             # Acquisition alert feed
│   │   │   ├── AlertCardView.swift          # Single alert item
│   │   │   └── AlertFilterPicker.swift
│   │   │
│   │   ├── Premium/
│   │   │   ├── PremiumPaywall.swift         # $9.99/month upsell screen
│   │   │   ├── PremiumFeatureRow.swift      # Feature comparison row
│   │   │   └── RestorePurchaseView.swift
│   │   │
│   │   └── Settings/
│   │       ├── SettingsView.swift
│   │       ├── NotificationSettingsView.swift
│   │       └── AboutView.swift
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/                 # App icons, brand colors
│   │   ├── SeedData/
│   │   │   └── sdk_catalog.json             # Bundled SDK dataset (150+ entries)
│   │   ├── Localizable.strings
│   │   └── Info.plist
│   │
│   └── Preview Content/
│       └── PreviewData.swift               # Mock data for Xcode previews
│
└── StainlessScoutTests/
    ├── StainlessScoutTests/
    │   ├── RiskScoreEngineTests.swift
    │   ├── SDKDataServiceTests.swift
    │   ├── SeedDataLoaderTests.swift
    │   └── PremiumServiceTests.swift
    └── StainlessScoutUITests/
        ├── SearchFlowUITests.swift
        └── PremiumGateUITests.swift
```

---

## 3. API Design

> **This is a fully offline app — no REST API.** All "API" contracts are internal Swift service interfaces (protocols), representing the boundaries between layers.

### 3.1 SDKDataService Protocol

```swift
protocol SDKDataServiceProtocol {

    // MARK: - Catalog Queries

    /// Returns all SDKs matching search text and optional filters
    func searchSDKs(
        query: String,
        category: SDKCategory?,
        minRiskScore: Int?,
        maxRiskScore: Int?
    ) -> [SDKEntity]

    /// Returns a single SDK by stable identifier
    func fetchSDK(id: UUID) -> SDKEntity?

    /// Returns SDKs in a given category, sorted by risk score descending
    func fetchSDKsByCategory(_ category: SDKCategory) -> [SDKEntity]

    /// Returns the N highest-risk SDKs across the entire catalog
    func fetchTopRiskSDKs(limit: Int) -> [SDKEntity]

    // MARK: - My Stack

    /// Adds an SDK to the user's personal stack
    func addToUserStack(sdkID: UUID) throws

    /// Removes an SDK from the user's stack
    func removeFromUserStack(sdkID: UUID) throws

    /// Returns all SDKs the user has added to their stack
    func fetchUserStack() -> [SDKEntity]

    // MARK: - Favorites

    func toggleFavorite(sdkID: UUID) throws
    func fetchFavorites() -> [SDKEntity]
}
```

### 3.2 RiskScoreEngine Interface

```swift
protocol RiskScoreEngineProtocol {

    /// Computes vulnerability score (1–10) for a single SDK
    /// Score factors: acquisition recency, acquirer track record,
    /// deprecation signals, community activity
    func computeScore(for sdk: SDKEntity) -> RiskScore

    /// Returns aggregate health for the user's entire stack
    func computeStackHealth(sdks: [SDKEntity]) -> StackHealthReport
}

struct RiskScore {
    let value: Int              // 1 (safe) – 10 (critical)
    let level: RiskLevel        // .safe | .caution | .warning | .critical
    let primaryFactor: String   // Human-readable reason e.g. "Acquired 3 months ago"
    let breakdown: [ScoreFactor]
}

struct ScoreFactor {
    let label: String
    let contribution: Int       // Points added to total score
    let detail: String
}

struct StackHealthReport {
    let overallScore: Double    // Average of all SDK scores
    let criticalSDKs: [SDKEntity]
    let safeSDKs: [SDKEntity]
    let totalTracked: Int
}

enum RiskLevel {
    case safe       // 1–3
    case caution    // 4–6
    case warning    // 7–8
    case critical   // 9–10
}
```

### 3.3 NotificationService Interface

```swift
protocol NotificationServiceProtocol {

    /// Requests UNUserNotificationCenter authorization
    func requestPermission() async -> Bool

    /// Schedules a local notification for a favorited SDK risk change
    func scheduleAcquisitionAlert(for sdk: SDKEntity, message: String) throws

    /// Cancels all pending notifications for an SDK (e.g., on unfavorite)
    func cancelNotifications(for sdkID: UUID)

    /// Rebuilds all notifications on app launch (reflects data update)
    func refreshAllScheduledNotifications()
}
```

### 3.4 PremiumService Interface

```swift
protocol PremiumServiceProtocol {

    /// Whether the user has an active premium subscription
    var isPremium: Bool { get }

    /// StoreKit 2 purchase flow; throws on cancellation or failure
    func purchasePremium() async throws -> PurchaseResult

    /// Restores prior subscription (App Store requirement)
    func restorePurchases() async throws

    /// Verifies subscription status against StoreKit transaction listener
    func refreshSubscriptionStatus() async
}

enum PurchaseResult {
    case success
    case pending
    case cancelled
    case failed(Error)
}
```

### 3.5 SeedDataLoader — JSON Contract

The bundled `sdk_catalog.json` file drives the entire catalog. Shape:

```json
{
  "version": "1.0.0",
  "generated": "2025-01-01",
  "sdks": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Parse SDK",
      "vendor": "Parse",
      "category": "backend",
      "description": "Mobile backend-as-a-service SDK",
      "language": ["Swift", "Objective-C"],
      "platforms": ["iOS", "Android"],
      "latestVersion": "4.2.0",
      "repositoryURL": "https://github.com/parse-community/Parse-SDK-iOS-OSX",
      "documentationURL": "https://docs.parseplatform.org",
      "riskFactors": {
        "acquisitionRecency": 8,
        "acquirerTrackRecord": 7,
        "deprecationSignals": 3,
        "communityActivity": 5
      },
      "status": "deprecated",
      "acquisitions": [
        {
          "id": "acq-001",
          "acquirer": "Facebook",
          "date": "2013-04-25",
          "type": "full_acquisition",
          "outcome": "shutdown",
          "shutdownDate": "2017-01-28",
          "notes": "Parse shut down 4 years after Facebook acquisition"
        }
      ],
      "alternatives": [
        {
          "id": "alt-001",
          "name": "Supabase",
          "reason": "Open source Firebase alternative with strong iOS support",
          "migrationComplexity": "medium",
          "migrationTemplateKey": "parse_to_supabase",
          "url": "https://supabase.com"
        }
      ],
      "tags": ["backend", "database", "auth"]
    }
  ]
}
```

---

## 4. Data Models

### 4.1 Core Data Entity Relationship Diagram

```
┌─────────────────────┐         ┌──────────────────────┐
│      SDKEntity      │────┐    │  AcquisitionEntity   │
│─────────────────────│    │    │──────────────────────│
│ id: UUID            │    │1:N │ id: UUID             │
│ name: String        │◄───┘────│ sdkID: UUID (FK)     │
│ vendor: String      │         │ acquirer: String     │
│ category: String    │         │ date: Date           │
│ descriptionText:    │         │ acquisitionType:     │
│   String            │         │   String             │
│ language: [String]  │         │ outcome: String      │
│ platforms: [String] │         │ shutdownDate: Date?  │
│ latestVersion:      │         │ notes: String?       │
│   String            │         └──────────────────────┘
│ repositoryURL:      │
│   String?           │         ┌──────────────────────┐
│ documentationURL:   │    1:N  │ AlternativeEntity    │
│   String?           │◄────────│──────────────────────│
│ status: String      │         │ id: UUID             │
│ riskScore: Int16    │         │ sdkID: UUID (FK)     │
│ isFavorite: Bool    │         │ name: String         │
│ isInUserStack: Bool │         │ reason: String       │
│ tags: String        │         │ migrationComplexity: │
│   (CSV)             │         │   String             │
│ lastUpdated: Date   │         │ migrationTemplateKey:│
│                     │         │   String?            │
│ riskRecency: Int16  │         │ url: String?         │
│ riskAcquirer: Int16 │         └──────────────────────┘
│ riskDeprecation:    │
│   Int16             │         ┌──────────────────────┐
│ riskCommunity:      │    N:1  │  UserStackEntity     │
│   Int16