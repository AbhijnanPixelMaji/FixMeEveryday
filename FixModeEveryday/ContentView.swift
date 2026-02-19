//
//  ContentView.swift
//  FixModeEveryday
//
//  Created by Abhijnan Maji on 21/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        MoodBloomMainView()
            .environmentObject(appState)
            .environmentObject(subscriptionManager)
            .environmentObject(themeManager)
            .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch themeManager.currentTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

struct MoodBloomMainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if !appState.hasCompletedOnboarding {
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}
