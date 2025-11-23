//
//  TransactionsView.swift
//  MoneyTracker
//
//  Transactions list view
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showAddTransaction = false
    @State private var selectedTransaction: Transaction?
    @State private var showFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                // Filter Chips
                FilterChipsView()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                // Transactions List
                if viewModel.filteredTransactions.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatDate(date))) {
                                ForEach(groupedTransactions[date] ?? []) { transaction in
                                    TransactionRowView(transaction: transaction)
                                        .onTapGesture {
                                            selectedTransaction = transaction
                                        }
                                }
                                .onDelete { indexSet in
                                    deleteTransactions(at: indexSet, for: date)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Transactions")
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
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionView(transaction: transaction)
            }
        }
    }
    
    private var groupedTransactions: [Date: [Transaction]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        return grouped
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func deleteTransactions(at offsets: IndexSet, for date: Date) {
        if let transactions = groupedTransactions[date] {
            for index in offsets {
                viewModel.deleteTransaction(transactions[index])
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search transactions...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}

struct FilterChipsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    isSelected: viewModel.selectedFilter == nil && viewModel.selectedCategory == nil,
                    action: {
                        viewModel.selectedFilter = nil
                        viewModel.selectedCategory = nil
                    }
                )
                
                FilterChip(
                    title: "Income",
                    isSelected: viewModel.selectedFilter == .income,
                    color: .green,
                    action: {
                        viewModel.selectedFilter = viewModel.selectedFilter == .income ? nil : .income
                    }
                )
                
                FilterChip(
                    title: "Expenses",
                    isSelected: viewModel.selectedFilter == .expense,
                    color: .red,
                    action: {
                        viewModel.selectedFilter = viewModel.selectedFilter == .expense ? nil : .expense
                    }
                )
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No transactions found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Tap the + button to add your first transaction")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    TransactionsView()
        .environmentObject(TransactionViewModel())
}
