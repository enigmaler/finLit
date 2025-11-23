//
//  TransactionViewModel.swift
//  MoneyTracker
//
//  ViewModel for transaction management
//

import Foundation
import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedFilter: TransactionType? = nil
    @Published var selectedCategory: TransactionCategory? = nil
    @Published var searchText: String = ""
    
    private let dataController = DataController.shared
    
    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        transactions = dataController.transactions.sorted { $0.date > $1.date }
    }
    
    func addTransaction(_ transaction: Transaction) {
        dataController.addTransaction(transaction)
        loadTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        dataController.deleteTransaction(transaction)
        loadTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        dataController.updateTransaction(transaction)
        loadTransactions()
    }
    
    var filteredTransactions: [Transaction] {
        var filtered = transactions
        
        if let selectedFilter = selectedFilter {
            filtered = filtered.filter { $0.type == selectedFilter }
        }
        
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.title.localizedCaseInsensitiveContains(searchText) ||
                transaction.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var totalBalance: Double {
        dataController.totalBalance
    }
    
    var monthlyIncome: Double {
        dataController.monthlyIncome
    }
    
    var monthlyExpense: Double {
        dataController.monthlyExpense
    }
    
    var categoryExpenses: [(category: TransactionCategory, amount: Double)] {
        let expenses = transactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.category }
        return grouped.map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
}
