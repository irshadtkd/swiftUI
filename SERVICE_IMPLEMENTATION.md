# Service Layer & Loading Indicator Implementation

## Overview
Implemented a proper service layer architecture with HomeService for API calls (currently using mock data) and added a beautiful loading indicator that matches the purple theme design.

## Files Created/Modified

### 1. HomeService.swift (NEW)
**Location**: `Features/Home/HomeService.swift`

**Features**:
- Singleton pattern with `shared` instance
- Async/await methods for modern Swift concurrency
- Mock data with simulated network delays
- Ready for real API integration

**Methods**:
- `fetchWordOfTheDay()` - Returns WordOfTheDay model (1.5s delay)
- `fetchUserStats()` - Returns UserStats model (1s delay)
- `saveWord(wordId:)` - Saves word to user's collection (0.5s delay)

**Mock Data**:
```swift
// Word: "Ephemeral"
// Stats: 7 day streak, 42 words learned, 12 saved words
```

**API Integration Ready**:
Each method includes commented examples showing how to replace mock data with actual API calls using URLSession.

---

### 2. LoadingView.swift (NEW - MOVED TO UTILITIES)
**Location**: `Utilities/LoadingView.swift` ✨ **Common Component**

**Features**:
- Now accessible throughout the entire app
- Located in Utilities for app-wide usage
- Multiple variants for different use cases

**Components**:

#### `LoadingView`
- Animated circular progress indicator
- Purple/white color scheme matching theme
- Smooth rotation animation
- "Loading..." text below spinner

#### `FullScreenLoadingView`
- Full screen loading with gradient background
- Used for initial data load

#### `ContentLoadingView`
- Content-area loading indicator
- Used within existing layouts

#### `LoadingOverlayView` ⭐ **NEW**
- Centered overlay with semi-transparent card
- Perfect for API refresh operations
- Non-blocking loading state

**Design Features**:
- ✅ Circular spinner with white stroke
- ✅ Smooth continuous rotation
- ✅ Semi-transparent background circle
- ✅ Matches purple gradient theme
- ✅ Responsive and lightweight
- ✅ **Reusable across all features**

---

### 3. HomeViewModel.swift (UPDATED)

**Changes**:
- ✅ Added `HomeService.shared` dependency
- ✅ Replaced mock data with service calls
- ✅ Added `errorMessage` published property
- ✅ Implemented async/await pattern
- ✅ Concurrent data fetching (word + stats)
- ✅ Added `refreshData()` method
- ✅ Added `saveWordSync()` wrapper for button actions

**New Properties**:
```swift
@Published var errorMessage: String?
private let service = HomeService.shared
```

**Key Methods**:
- `loadData()` - Fetches word and stats concurrently
- `saveWord()` - Async save with error handling
- `saveWordSync()` - Synchronous wrapper for UI actions
- `refreshData()` - Triggers data reload

---

### 4. HomeView.swift (UPDATED)

**Loading States**:

1. **Initial Load** (no data):
   - Shows `ContentLoadingView` with full screen loading indicator
   - Purple gradient background maintained

2. **Refresh Load** (data exists):
   - Shows loading overlay in center
   - Semi-transparent card with loading spinner
   - Content remains visible underneath

3. **Error State**:
   - Red-tinted error message card
   - Shows error icon and message
   - "Retry" button to reload data

**New Features**:
- ✅ Pull-to-refresh functionality (`.refreshable`)
- ✅ Error message display with retry button
- ✅ Loading overlay during refresh
- ✅ Conditional rendering based on loading state

**UI Components Added**:
```swift
errorMessageView(message:) // Error display with retry
```

---

## Data Flow

```
HomeView
    ↓
HomeViewModel
    ↓
HomeService (Mock API)
    ↓
Returns: WordOfTheDay + UserStats
```

### Loading Sequence:
1. User opens home screen
2. ViewModel calls `loadData()`
3. Service fetches data (mock with 1.5s delay)
4. Loading indicator shows during fetch
5. Data populates UI when complete
6. Error shown if fetch fails

### Refresh Sequence:
1. User pulls down to refresh
2. Native pull-to-refresh triggers
3. ViewModel calls `loadData()`
4. Loading overlay appears
5. Data updates when complete

---

## Mock Data Delays

- **Word of the Day**: 1.5 seconds
- **User Stats**: 1.0 seconds
- **Save Word**: 0.5 seconds

These delays simulate real network conditions and allow testing of loading states.

---

## Next Steps for Real API Integration

### 1. Update HomeService.swift:
Replace mock implementations with actual API calls:

```swift
func fetchWordOfTheDay() async throws -> WordOfTheDay {
    let url = URL(string: "\(APIEndpoints.baseURL)/word-of-the-day")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let word = try JSONDecoder().decode(WordOfTheDay.self, from: data)
    return word
}
```

### 2. Add API Endpoints:
Update `AppEndpoints.swift` with:
```swift
static let wordOfTheDay = "/api/v1/word-of-the-day"
static let userStats = "/api/v1/user/stats"
static let saveWord = "/api/v1/user/saved-words"
```

### 3. Add Error Handling:
Extend `AppErrors.swift` with:
```swift
case networkError
case decodingError
case serverError(Int)
```

---

## Testing the Implementation

1. **Initial Load**: Open home screen → See loading spinner → Data appears
2. **Pull to Refresh**: Pull down → Loading overlay → Data refreshes
3. **Save Word**: Tap "Save Word" → Stats update (saved words +1)
4. **Error Handling**: Simulate error → Error message appears → Tap retry

---

## Design Consistency

All components use the common theme classes:
- **Colors**: `AppColors` (gradients, text, backgrounds)
- **Fonts**: `AppFonts` (consistent typography)
- **Theme**: `AppTheme` (spacing, corner radius)

The loading indicator perfectly matches the purple gradient theme with white accents and semi-transparent cards.
