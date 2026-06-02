//
//  ContentView.swift
//  Stainless Scout
//
//  Root tab container. Houses all main navigation tabs.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var sdkService: SDKService
    @EnvironmentObject var purchaseService: PurchaseService
    @State private var selectedTab: Tab = .dashboard
    @State private var navigateToSDKId: String? = nil
    
    // MARK: - Tab Definition
    enum Tab: Int, CaseIterable {
        case dashboard = 0
        case scanner
        case directory
        case favorites
        case premium
        
        var title: String {
            switch self {
            case .dashboard: return "Dashboard"
            case .scanner: return "Scanner"
            case .directory: return "Directory"
            case .favorites: return "Favorites"
            case .premium: return "Premium"
            }
        }
        
        var icon: String {
            switch self {
            case .dashboard: return "chart.bar.fill"
            case .scanner: return "shield.lefthalf.filled"
            case .directory: return "list.bullet.rectangle.fill"
            case .favorites: return "star.fill"
            case .premium: return "crown.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label(Tab.dashboard.title, systemImage: Tab.dashboard.icon)
                }
                .tag(Tab.dashboard)
            
            ScannerView()
                .tabItem {
                    Label(Tab.scanner.title, systemImage: Tab.scanner.icon)
                }
                .tag(Tab.scanner)
            
            DirectoryView()
                .tabItem {
                    Label(Tab.directory.title, systemImage: Tab.directory.icon)
                }
                .tag(Tab.directory)
            
            FavoritesView()
                .tabItem {
                    Label(Tab.favorites.title, systemImage: Tab.favorites.icon)
                }
                .tag(Tab.favorites)
            
            PremiumView()
                .tabItem {
                    Label(Tab.premium.title, systemImage: Tab.premium.icon)
                }
                .tag(Tab.premium)
        }
        .accentColor(AppTheme.accentGreen)
        .onReceive(NotificationCenter.default.publisher(for: .navigateToSDK)) { notification in
            if let sdkId = notification.userInfo?["sdkId"] as? String {
                navigateToSDKId = sdkId
                selectedTab = .directory
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SDKService(context: PersistenceController.preview.container.viewContext))
        .environmentObject(PurchaseService())
        .environmentObject(NotificationService())
}
