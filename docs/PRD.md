# Stainless Scout — Product Requirements Document

**Version:** 1.0
**Date:** 2025
**Status:** Draft
**Platform:** iOS (SwiftUI + Core Data)

---

## 1. Executive Summary

Stainless Scout is an iOS app that helps developers track the acquisition status and deprecation risk of third-party SDKs they rely on in their projects. In the wake of accelerating AI company acquisitions and the resulting SDK chaos — deprecations, pivots, and sudden shutdowns — developers need a fast, offline-capable reference tool to assess their stack's stability and find safe alternatives. The app maintains a curated local database of SDKs, their acquisition histories, and risk scores, with a premium tier unlocking migration templates and detailed risk assessments at $9.99/month.

---

## 2. Goals & Success Metrics

### Business Goals
- Reach 500 active installs within 30 days of App Store launch
- Convert 5–10% of free users to the premium tier within 90 days
- Establish Stainless Scout as the go-to reference app for developer stack hygiene

### User Goals
- Reduce the time it takes a developer to assess SDK acquisition risk from hours of Googling to under 60 seconds
- Give developers actionable next steps (alternatives, migration paths) rather than just raw information

### Success Metrics

| Metric | Target (30 days) | Target (90 days) |
|---|---|---|
| Total installs | 500 | 2,000 |
| DAU / MAU ratio | ≥ 20% | ≥ 25% |
| Premium conversions | — | ≥ 5% of installs |
| SDK catalog size | ≥ 150 SDKs at launch | ≥ 200 (via app update) |
| Avg. session length | ≥ 90 seconds | ≥ 120 seconds |
| App Store rating | — | ≥ 4.3 stars |
| Favorited SDKs per user | ≥ 3 | ≥ 5 |

---

## 3. User Personas

### Persona 1 — "The Indie Dev" (Primary)
**Name:** Marcus, 31
**Role:** Independent iOS/Android developer building a SaaS side project
**Technical Level:** Intermediate–Advanced
**Pain Point:** Marcus uses 8–12 third-party SDKs across his projects. He found out Heroku's free tier was killed only after his app broke in production. He now worries the same will happen with AI-related SDKs in his stack (analytics, LLM wrappers, etc.).
**Motivation:** He wants a quick, trustworthy way to know if any SDK he's using is "endangered" — without reading tech Twitter all day.
**Key Behaviors:** Uses his iPhone during commute, checks Stack Overflow daily, values speed and clarity over polish.

---

### Persona 2 — "The Startup CTO" (Secondary)
**Name:** Priya, 38
**Role:** CTO at a 12-person startup
**Technical Level:** Expert
**Pain Point:** Her team has 3 engineers and can't afford the time cost of a surprise SDK migration mid-sprint. She needs to proactively audit their stack and prioritize risk remediation.
**Motivation:** Wants a reference tool she can pull up in investor or engineering meetings to show she's managing technical risk responsibly.
**Key Behaviors:** Uses premium tools without hesitation if they save engineering hours; shares useful apps with her team via Slack.

---

### Persona 3 — "The Agency Developer" (Tertiary)
**Name:** Daniel, 26
**Role:** Mid-level developer at a digital agency, maintains 5–8 client apps simultaneously
**Technical Level:** Intermediate
**Pain Point:** He inherits client codebases with SDKs he didn't choose. When a client asks "is this SDK still safe to use?", he has no fast answer.
**Motivation:** Wants to quickly look up an unfamiliar SDK and give a client an informed recommendation at the next meeting.
**Key Behaviors:** Values offline functionality, uses dark mode exclusively, frequently searches for package names.

---

## 4. Core Features

### Priority Definitions
- **P0 — Must Have:** App cannot ship without this
- **P1 — Should Have:** Strongly desired for v1, ship if time allows
- **P2 — Nice to Have:** Deferred to v1.1 or later

---

### P0 — Core (MVP Critical)

#### 4.1 Local SDK Database (Core Data)
The foundation of the app. A pre-populated Core Data store ships with the app containing a curated catalog of SDKs.

**Each SDK record must include:**
- SDK name and vendor/company name
- Category (e.g., AI/ML, Analytics, Authentication, Payments, Storage, Messaging)
- Acquisition status: `Active`, `Acquired`, `Deprecated`, `Shutdown`, `At Risk`
- Acquisition details: acquirer name, acquisition date, announced changes
- Vulnerability score: integer 1–10 (1 = stable, 10 = critical risk)
- Score rationale: 1–2 sentence plain-English explanation of the score
- Last reviewed date
- Official documentation URL (for reference, displayed as text)
- At least 2–3 alternative SDK recommendations per entry

**Minimum catalog size at launch:** 150 SDKs across at least 8 categories

---

#### 4.2 SDK Search & Browse
The primary entry point for all users.

**Requirements:**
- Full-text search bar visible immediately on app launch
- Search queries against SDK name, vendor name, and category
- Results appear with each keystroke (no submit button required)
- Each result card displays: SDK name, vendor, status badge (color-coded), and vulnerability score
- Browse by category via a horizontally scrollable category filter row
- "Recently Viewed" section on the home screen showing last 5 lookups (stored locally)
- Empty state with suggested popular SDKs when no query is entered

**Status Badge Color Coding:**
- 🟢 Active — Green
- 🟡 At Risk — Yellow/Amber
- 🔴 Acquired / Deprecated — Red
- ⚫ Shutdown — Dark Gray

---

#### 4.3 SDK Detail View
Tapping any SDK result opens a full detail screen.

**Required sections:**
- Header: SDK name, vendor, status badge, vulnerability score (displayed as a visual gauge/meter, 1–10)
- Acquisition Summary: plain-English explanation of what happened and when
- Risk Rationale: why this score was assigned
- Alternatives section: 2–3 recommended alternatives, each tappable to navigate to their own SDK detail view
- "Add to My Stack" button (saves to favorites/Core Data)
- Share button: generates a plain-text summary shareable via iOS share sheet

---

#### 4.4 My Stack (Favorites & Tracking)
Users build a personal watchlist of SDKs they use.

**Requirements:**
- "My Stack" tab in the main tab bar
- Add/remove SDKs from the stack via the SDK detail view
- My Stack list view shows all saved SDKs sorted by vulnerability score (highest risk first, by default)
- Total stack risk summary at the top: a count of SDKs by status category (e.g., "3 At Risk, 1 Deprecated, 8 Active")
- Empty state with clear CTA to search and add SDKs

---

#### 4.5 Dark Mode Support
- Full support for iOS system dark mode and light mode
- App should respect the system setting by default
- Developer-focused aesthetic: neutral grays, clear typography, monospace font accents for SDK names and score values

---

### P1 — Should Have

#### 4.6 Vulnerability Score Filter & Sorting
- Filter My Stack and browse results by score range (e.g., show only SDKs with score ≥ 7)
- Sort search results by: vulnerability score (high/low), name (A–Z), most recently updated
- Filter by status type (Active, At Risk, Acquired, Deprecated, Shutdown)

---

#### 4.7 Local Push Notifications — Acquisition Alerts
Since the app is fully offline with no backend, notifications are triggered by app update events.

**Requirements:**
- When the user updates the app and the local database is refreshed, the app checks if any SDK in the user's "My Stack" has a changed status or increased vulnerability score
- If a change is detected, a local push notification is scheduled: *"⚠️ [SDK Name] status changed to Acquired — tap to review alternatives"*
- User must grant notification permissions (standard iOS permission prompt, requested after adding first SDK to My Stack)
- Notification settings toggle in the app's Settings screen

---

#### 4.8 App Settings Screen
- Toggle: Enable/disable acquisition alert notifications
- Toggle: Dark mode override (System / Always Dark / Always Light)
- "Last database update" timestamp
- "About Stainless Scout" section with app version
- Link to rate the app on the App Store
- Premium subscription status and management link

---

#### 4.9 Premium Unlock — "Scout Pro"
**Free tier includes:** All search, browse, SDK detail, and My Stack functionality.
**Scout Pro ($9.99/month) unlocks:**

| Feature | Free | Scout Pro |
|---|---|---|
| Full SDK catalog | ✅ | ✅ |
| Vulnerability scores | ✅ | ✅ |
| My Stack (up to 10 SDKs) | ✅ | Unlimited |
| Basic alternative recommendations | ✅ | ✅ |
| Acquisition alert notifications | ❌ | ✅ |
| Migration templates | ❌ | ✅ |
| Detailed risk assessment breakdown | ❌ | ✅ |
| Stack export (CSV/plain text) | ❌ | ✅ |

**Implementation notes:**
- Use StoreKit 2 for in-app purchase and subscription management
- Paywall screen shown when a free user attempts to access a Pro feature
- Paywall must include: feature comparison, price, monthly billing disclosure, restore purchase button, and privacy/terms links
- No free trial required in v1

---

#### 4.10 Migration Templates (Pro Feature)
For SDKs with a status of Acquired, Deprecated, or Shutdown, Pro users see a "Migration Guide" section in the SDK detail view.

**Template content includes:**
- Recommended replacement SDK (from the alternatives list)
- High-level migration steps (3–5 bullet points written in plain English, not code)
- Estimated effort level: Low / Medium / High
- Key breaking changes to be aware of
- This content is stored as structured text in Core Data and ships with the app

---

#### 4.11 Detailed Risk Assessment (Pro Feature)
An expanded breakdown of the vulnerability score for Pro users, visible on the SDK detail screen below the standard score gauge.

**Breakdown factors (displayed as sub-scores):**
- Acquisition confidence: how certain is the acquisition/shutdown? (Confirmed / Rumored / Speculative)
- Community health: activity level of the SDK's open-source community or vendor support status
- Timeline urgency: how soon developers may need to act (Immediate / 6 months / 12+ months)
- Migration complexity: how hard is it to replace this SDK? (Low / Medium / High)

---

### P2 — Nice to Have (Post-v1)

#### 4.12 Stack Export (Pro Feature — v1.1)
- Export the user's My Stack list as a plain-text or CSV file via the iOS share sheet
- Fields exported: SDK name, vendor, status, vulnerability score, last reviewed date

#### 4.13 "Scan My Stack" Bulk Input (v1.1)
- A text area where users can paste a list of SDK/package names (e.g., from a `package.json` or `Podfile`)
- The app fuzzy-matches the input against the local database and generates a bulk stack report

#### 4.14 Trending / Recently Acquired Widget (v1.1)
- iOS home screen widget showing the 3 highest-risk SDKs across the entire catalog, refreshed on app update

---

## 5. User Stories

### Discovery & Onboarding

**US-01**
*As a developer who just downloaded the app, I want to see a clear home screen with a search bar and category filters so that I can immediately start looking up SDKs without needing a tutorial.*

**US-02**
*As a first-time user, I want to understand what vulnerability scores mean so that I can interpret the results without guessing.*
> Acceptance criteria: A persistent "?" info button near the score gauge opens a brief tooltip or modal explaining the 1–10 scale.

---

### Core Search & Discovery

**US-03**
*As an indie developer, I want to search for an SDK by name and see its acquisition status and risk score in under 5 seconds so that I can quickly triage my tech stack.*

**US-04**
*As a developer browsing by category, I want to filter the SDK catalog by "AI/ML" so that I can see all AI-adjacent SDKs and their risk levels in one view.*

**US-05**
*As a developer reviewing an at-risk SDK, I want to see 2–3 recommended alternatives directly on the SDK detail screen so that I know my options without leaving the app.*

**US-06**
*As a developer, I want to tap an alternative recommendation and navigate to that SDK's own detail page so that I can compare risk levels before deciding on a migration path.*

---

### My Stack Management

**US-07**
*As a developer managing multiple projects, I want to save SDKs to "My Stack" so that I can track the specific tools I'm currently using without re-searching every time.*

**US-08**
*As a developer reviewing my saved stack, I want to see my SDKs sorted by vulnerability score with a summary count of at-risk SDKs at the top so that I immediately know where to focus my attention.*

**US-09**
*As a free-tier user, I want to know I'm approaching my 10 SDK limit in My Stack so that I'm not surprised when I'm blocked from adding more.*
> Acceptance criteria: A counter (e.g., "7 / 10 SDKs") is displayed in the My Stack header. At 10, adding more shows a Pro upgrade prompt.

---

### Alerts & Notifications

**US-10**
*As a developer who tracks SDKs in My Stack, I want to receive a push notification when an app update changes the status of an SDK I'm watching so that I'm not caught off guard by deprecations.*

**US-11**
*As a developer who doesn't want notification interruptions, I want to disable acquisition alerts in Settings so that I can use the tracking features without push notifications.*

---

### Premium / Pro Features

**US-12**
*As a startup CTO evaluating risk, I want to see a detailed breakdown of why an SDK received its vulnerability score (acquisition confidence, timeline urgency, migration complexity) so that I can make an informed, defensible decision for my team.*

**US-13**
*As a Pro subscriber, I want to view a plain-English migration template for a deprecated SDK so that I can scope the effort required and communicate it to stakeholders without deep research.*

**US-14**
*As a developer considering the premium upgrade, I want to see a clear feature comparison on the paywall screen so that I understand exactly what I'm paying for before subscribing.*

**US-15**
*As a Pro subscriber, I want to export my full My Stack list as a text file so that I can paste it into a team Notion doc or share it in a Slack channel.*

---

### Sharing & Utility

**US-16**
*As a developer, I want to share an SDK's risk summary via the iOS share sheet so that I can quickly alert a colleague or paste it into a pull request comment.*

---

## 6. Out of Scope (v1)

The following will **not** be built for the initial release:

| Item | Reason / Future Consideration |
|---|---|
| Backend API or server infrastructure | Complexity and cost; all data ships with the app and updates via App Store releases |
| Real-time data sync or live web scraping | Requires backend; considered for v2 with a proper data pipeline |
| User accounts / login / cloud sync | Adds significant scope; Core Data is sufficient for local persistence in v1 |
| Community-submitted SDK entries or corrections | Trust/moderation overhead; may revisit with a submission form in v2 |
| Android / cross-platform version | iOS only for v1 to manage scope |
| Web app or browser extension | Out of platform scope for v1 |
| Direct integration with package managers (npm, CocoaPods, etc.) | Bulk stack scanning deferred to v1.1 (see P2 feature 4.13) |
| Automated SDK status fetching via GitHub or registry APIs | No third-party APIs in v1 per brief constraints |
| Team / organization accounts | Single-user product in v1 |
| In-app chat or support | Handled via App Store reviews and an email link in Settings |
| iPad-optimized layout | iPhone only for v1;