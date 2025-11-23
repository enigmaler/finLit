//
//  ContentView.swift
//  MoneyTracker
//
//  Main content view with tab navigation
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
