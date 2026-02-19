# ✅ PromptButton Argument Label Fix Applied

## Problem
Missing argument label 'title:' in PromptButton calls in NewJournalEntryView.swift

## Solution Applied
Updated all PromptButton calls to include the `title:` parameter label:

**Before:**
```swift
PromptButton("How am I feeling right now?") {
    appendToContent("How am I feeling right now?\n\n")
}
```

**After:**
```swift
PromptButton(title: "How am I feeling right now?") {
    appendToContent("How am I feeling right now?\n\n")
}
```

## ✅ Changes Made
- Fixed 4 PromptButton calls in the promptSection
- All calls now properly include the `title:` parameter label
- No other changes needed

The build error should now be resolved! Try building again with Cmd+R in Xcode.