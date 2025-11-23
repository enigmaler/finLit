//
//  HomeView.swift
//  MoneyTracker
//
//  Home screen with balance overview
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showAddTransaction = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Balance Card
                    BalanceCardView()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Quick Stats
                    QuickStatsView()
                        .padding(.horizontal)
                    
                    // Recent Transactions
                    RecentTransactionsView()
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Money Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTransaction = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView()
            }
        }
    }
}

struct BalanceCardView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(formatCurrency(viewModel.totalBalance))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(viewModel.totalBalance >= 0 ? .green : .red)
            
            HStack(spacing: 32) {
                VStack {
                    Text("Income")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatCurrency(viewModel.monthlyIncome))
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack {
                    Text("Expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatCurrency(viewModel.monthlyExpense))
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct QuickStatsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Month")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Income",
                    amount: viewModel.monthlyIncome,
                    color: .green,
                    icon: "arrow.down.circle.fill"
                )
                
                StatCard(
                    title: "Expenses",
                    amount: viewModel.monthlyExpense,
                    color: .red,
                    icon: "arrow.up.circle.fill"
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(formatCurrency(amount))
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct RecentTransactionsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var recentTransactions: [Transaction] {
        Array(viewModel.transactions.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.headline)
                .padding(.horizontal)
            
            if recentTransactions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No transactions yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal)
            } else {
                ForEach(recentTransactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(TransactionViewModel())
}
