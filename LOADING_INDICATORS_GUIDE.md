# Loading Indicators - Quick Reference Guide

## 📍 Location
`Utilities/LoadingView.swift` - **Common component accessible app-wide**

---

## 🎯 Which Loading Indicator to Use?

### 1. Initial Screen Load (No Data Yet)
**Use:** `ContentLoadingView()`

```swift
var body: some View {
    ZStack {
        // Background
        
        if viewModel.isLoading && viewModel.data == nil {
            ContentLoadingView()
        } else {
            // Your content
        }
    }
}
```

**When to use:**
- ✅ First time loading a screen
- ✅ No data to display yet
- ✅ Replacing entire content area

---

### 2. Full Screen Loading
**Use:** `FullScreenLoadingView()`

```swift
if isInitializing {
    FullScreenLoadingView()
} else {
    MainContentView()
}
```

**When to use:**
- ✅ App initialization
- ✅ Major state transitions
- ✅ Need gradient background

---

### 3. Refresh/Background Operations
**Use:** `LoadingOverlayView()`

```swift
ZStack {
    // Your existing content
    
    if viewModel.isLoading && viewModel.data != nil {
        LoadingOverlayView()
    }
}
```

**When to use:**
- ✅ Pull-to-refresh
- ✅ Background API calls
- ✅ Content already visible
- ✅ Non-blocking operations

---

### 4. Custom Layouts
**Use:** `LoadingView()`

```swift
VStack {
    if isLoading {
        LoadingView()
    } else {
        CustomContent()
    }
}
```

**When to use:**
- ✅ Embedding in custom layouts
- ✅ Need just the spinner
- ✅ Custom positioning required

---

## 💡 Common Patterns

### Pattern 1: Initial Load + Refresh
```swift
var body: some View {
    ZStack {
        LinearGradient(...)
            .ignoresSafeArea()
        
        if viewModel.isLoading && viewModel.data == nil {
            // First load
            ContentLoadingView()
        } else {
            ScrollView {
                // Content
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        
        // Refresh overlay
        if viewModel.isLoading && viewModel.data != nil {
            LoadingOverlayView()
        }
    }
}
```

### Pattern 2: List with Loading
```swift
List {
    ForEach(items) { item in
        ItemRow(item: item)
    }
    
    if isLoadingMore {
        HStack {
            Spacer()
            LoadingView()
            Spacer()
        }
    }
}
```

### Pattern 3: Button with Loading
```swift
Button(action: {
    viewModel.performAction()
}) {
    if viewModel.isProcessing {
        LoadingView()
            .scaleEffect(0.5)
    } else {
        Text("Submit")
    }
}
```

---

## 🎨 Customization

All loading views use theme colors:
- Spinner: `AppColors.textPrimary` (white)
- Background: `AppColors.cardBackground` (semi-transparent)
- Border: `AppColors.cardBorder`
- Text: `AppColors.textSecondary`

To customize, modify `AppColors` in `Core/Theme/AppColors.swift`

---

## ✅ Best Practices

1. **Always show loading state** for async operations
2. **Use appropriate variant** based on context
3. **Don't block UI** unnecessarily - prefer overlay
4. **Combine with error handling** for better UX
5. **Test loading states** during development

---

## 🚫 Common Mistakes

❌ **Don't:**
```swift
// Blocking entire screen for small operations
if isLoading {
    FullScreenLoadingView()
}
```

✅ **Do:**
```swift
// Use overlay for non-critical operations
ZStack {
    Content()
    if isLoading {
        LoadingOverlayView()
    }
}
```

---

## 📱 Preview

All loading views have Xcode previews:
- Preview "Loading Indicator"
- Preview "Full Screen Loading"
- Preview "Content Loading"
- Preview "Loading Overlay"

Use previews to see how they look before implementing!
