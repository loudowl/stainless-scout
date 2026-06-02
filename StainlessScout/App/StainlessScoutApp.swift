//
//  StainlessScoutApp.swift
//  Stainless Scout
//
//  Main entry point. Sets up Core Data stack, seeds initial data,
//  configures notification delegate, and injects environment objects.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct StainlessScoutApp: App {
    
    // MARK: - Environment & State
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    @StateObject private var sdkService: SDKService
    @StateObject private var purchaseService = PurchaseService()
    @StateObject private var notificationService = NotificationService()
    
    // MARK: - Init
    init() {
        let context = PersistenceController.shared.container.viewContext
        let service = SDKService(context: context)
        _sdkService = StateObject(wrappedValue: service)
        
        // Configure navigation bar appearance for dark theme
        configureAppearance()
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(sdkService)
                .environmentObject(purchaseService)
                .environmentObject(notificationService)
                .preferredColorScheme(.dark) // Force dark mode for developer aesthetic
                .onAppear {
                    // Seed data on first launch
                    seedDataIfNeeded()
                    // Request notification permissions
                    notificationService.requestPermission()
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func seedDataIfNeeded() {
        let context = persistenceController.container.viewContext
        SDKSeeder.seedIfNeeded(context: context)
    }
    
    private func configureAppearance() {
        // Navigation Bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppTheme.backgroundPrimary)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppTheme.textPrimary),
            .font: UIFont.monospacedSystemFont(ofSize: 17, weight: .semibold)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(AppTheme.textPrimary),
            .font: UIFont.monospacedSystemFont(ofSize: 34, weight: .bold)
        ]
        navAppearance.shadowColor = UIColor(AppTheme.borderColor)
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        // Tab Bar
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(AppTheme.backgroundSecondary)
        tabAppearance.shadowColor = UIColor(AppTheme.borderColor)
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = UIColor(AppTheme.accentGreen)
        UITabBar.appearance().unselectedItemTintColor = UIColor(AppTheme.textMuted)
    }
}
